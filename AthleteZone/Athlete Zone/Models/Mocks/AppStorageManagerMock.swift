//
//  AppStorageManagerMock.swift
//  Athlete Zone Tests
//
//  Created by Jan Prokorát on 14.11.2023.
//

// @testable import Athlete_Zone
import Dependencies
import Foundation

struct AppStorageManagerMock {
    static var shared = AppStorageManagerMock()

    var widgetWorkout: String?
    var widgetTraining: String?

    var selectedWorkoutId: String = ""
    var selectedTrainingId: String = ""
    var selectedSection: Section = .workout
    var language: Language = .cze
    var stopWatchType: TimerType = .stopWatch

    var soundsEnabled = false
    var hapticsEnabled = false
    var notificationsEnabled = false
    var runInBackground = false

    func loadFromAppStorage<T>(forKey key: DefaultItem) -> T? where T: Codable {
        switch key {
        case .language:
            return language as? T

        case .selectedWorkoutId:
            return selectedWorkoutId as? T

        case .selectedTrainingId:
            return selectedTrainingId as? T

        case .soundsEnabled:
            return soundsEnabled as? T

        case .hapticsEnabled:
            return hapticsEnabled as? T

        case .notificationsEnabled:
            return notificationsEnabled as? T

        case .selectedSection:
            return selectedSection as? T

        case .stopWatchType:
            return stopWatchType as? T

        case .runInBackground:
            return runInBackground as? T

        default:
            return nil
        }
    }
}
