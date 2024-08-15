//
//  Constants.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 26.07.2024.
//

import Foundation

class Constants {
    /// Time interval for preparation time before workouts
    static let PreparationTickInterval: TimeInterval = 10

    /// Tick interval for timer of workout and training
    static let WorkoutTickInterval: TimeInterval = 1

    /// Time interval for timer
    static let TimerTickInterval: TimeInterval = 1

    /// Time interval for stopwatch
    static let StopwatchTickInterval: TimeInterval = 0.01

    /// Range of intervals, when user should be notified by sound or haptics
    static let NotificationRange: ClosedRange<TimeInterval> = 1 ... 3
}
