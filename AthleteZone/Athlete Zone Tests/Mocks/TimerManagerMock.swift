//
//  TimerManagerMock.swift
//  Athlete Zone Tests
//
//  Created by Jan Prokorát on 21.11.2023.
//

@testable import Athlete_Zone
import Foundation

class TimerManagerMock: TimerProtocol {
    @Published var timeElapsed: TimeInterval = 0

    var timeElapsedPublisher: Published<TimeInterval>.Publisher {
        $timeElapsed
    }

    func startTimer() {
        timeElapsed = 1
    }

    func stopTimer() {
        timeElapsed = 0
    }

    func pauseTimer() {
        timeElapsed = 2
    }

    func startTimer(_ interval: TimeInterval, kind: Athlete_Zone.TimerKind, inBackground: Bool) {
        timeElapsed = 1
    }
}
