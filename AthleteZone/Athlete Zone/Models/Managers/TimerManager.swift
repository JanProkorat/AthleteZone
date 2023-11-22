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
    static let timerUpdatedNotification = Notification.Name("BackgroundTimerUpdatedNotification")

    private init() {}

    var timePublisher: AnyPublisher<TimeInterval, Never> {
        Just(timeElapsed)
            .merge(with: NotificationCenter
                .default.publisher(for: TimerManager.timerUpdatedNotification).map { _ in
                    self.timeElapsed
                })
            .eraseToAnyPublisher()
    }

    func startTimer() {
        timeElapsed = 0
        scheduleBackgroundTask()

        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
                guard let self = self else { return }
                self.timeElapsed += timer.timeInterval
                NotificationCenter
                    .default.post(name: TimerManager.timerUpdatedNotification, object: nil)
            }
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
        endBackgroundTask()
    }

    func pauseTimer() {
        timer?.invalidate()
        timer = nil
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
