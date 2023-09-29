//
//  TimerMnager.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 01.08.2023.
//

import Combine
import Foundation

class TimerManager: ObservableObject, TimerProtocol {
    static let shared = TimerManager()
    private var timer: Cancellable?

    var timeElapsedPublisher: Published<TimeInterval>.Publisher {
        $timeElapsed
    }

    @Published var timeElapsed: TimeInterval = 0

    func startTimer() {
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.timeElapsed += 1
            }
    }

    func stopTimer() {
        timer?.cancel()
        timer = nil
        timeElapsed = 0
    }
}
