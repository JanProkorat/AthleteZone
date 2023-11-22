//
//  AppStorageManagerMock.swift
//  Athlete Zone Tests
//
//  Created by Jan Prokorát on 14.11.2023.
//

@testable import Athlete_Zone
import Foundation

class AppStorageManagerMock: AppStorageProtocol {
    private var widgetWorkout: String?
    private var widgetTraining: String?

    var selectedWorkoutId: String = ""
    var selectedTrainingId: String = ""
    var selectedSection: Section = .workout
    var language: Language = .en

    var soundsEnabled: Bool = false
    var hapticsEnabled: Bool = false
    var notificationsEnabled: Bool = false

    func storeToUserDefaults(data: String, key: Athlete_Zone.UserDefaultValues) {
        switch key {
        case .workoutId:
            widgetWorkout = data

        case .trainingId:
            widgetTraining = data

        default:
            break
        }
    }

    func loadFromDefaults(key: Athlete_Zone.UserDefaultValues) -> String? {
        switch key {
        case .workoutId:
            return widgetWorkout

        case .trainingId:
            return widgetTraining

        default:
            return nil
        }
    }

    func removeFromDefaults(key: Athlete_Zone.UserDefaultValues) {
        switch key {
        case .workoutId:
            widgetWorkout = nil

        case .trainingId:
            widgetTraining = nil

        default:
            break
        }
    }
}
