//
//  TimerProtocol.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 01.08.2023.
//

import Foundation

protocol TimerProtocol: ObservableObject {
    var timeElapsed: TimeInterval { get }
    var timeElapsedPublisher: Published<TimeInterval>.Publisher { get }

    func startTimer()
    func stopTimer()
    func pauseTimer()
}
