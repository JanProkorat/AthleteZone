//
//  TimerManager.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 30.07.2023.
//

import Combine
import Foundation
import UIKit

class TimerManager: TimerProtocol {
    static let shared = TimerManager()

    var timeElapsedPublisher: Published<TimeInterval>.Publisher {
        $timeElapsed
    }

    @Published var timeElapsed: TimeInterval = 0

    private var timer: Timer?
    private var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    static let workoutTimerNotification = Notification.Name(TimerKind.workout.rawValue)
    static let stopWatchTimerNotification = Notification.Name(TimerKind.stopWatch.rawValue)

    private init() {}

    var timePublisher: AnyPublisher<TimeInterval, Never> {
        Just(timeElapsed)
            .merge(with: NotificationCenter
                .default.publisher(for: TimerManager.workoutTimerNotification).map { _ in
                    self.timeElapsed
                })
            .eraseToAnyPublisher()
    }

    func startTimer(_ interval: TimeInterval, kind: TimerKind, inBackground: Bool = false) {
        if inBackground {
            scheduleBackgroundTask()
        }

        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] timer in
                guard let self = self else { return }
                self.timeElapsed += timer.timeInterval
                if inBackground {
                    NotificationCenter.default.post(name: kind == .workout ?
                        TimerManager.workoutTimerNotification :
                        TimerManager.stopWatchTimerNotification, object: nil)
                    RunLoop.current.add(timer, forMode: .common)
                }
            }
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
        endBackgroundTask()
        timeElapsed = 0
    }

    func pauseTimer() {
        timer?.invalidate()
        timer = nil
        endBackgroundTask()
    }

    private func scheduleBackgroundTask() {
        let application = UIApplication.shared
        backgroundTask = application.beginBackgroundTask { [weak self] in
            self?.endBackgroundTask()
        }
    }

    private func endBackgroundTask() {
        let application = UIApplication.shared
        application.endBackgroundTask(backgroundTask)
        backgroundTask = .invalid
    }
}
