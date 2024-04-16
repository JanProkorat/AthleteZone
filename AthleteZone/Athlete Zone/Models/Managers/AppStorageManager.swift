//
//  AppStorageManager.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 19.02.2023.
//

import Dependencies
import Foundation
import SwiftUI

struct AppStorageValues {
    static let shared = AppStorageValues()

    @AppStorage(DefaultItem.selectedWorkoutId.rawValue,
                store: UserDefaults(suiteName: UserDefaultValues.groupId.rawValue))
    var selectedWorkoutId: String = ""

    @AppStorage(DefaultItem.selectedTrainingId.rawValue,
                store: UserDefaults(suiteName: UserDefaultValues.groupId.rawValue))
    var selectedTrainingId: String = ""

    @AppStorage(DefaultItem.selectedSection.rawValue,
                store: UserDefaults(suiteName: UserDefaultValues.groupId.rawValue))
    var selectedSection: Section = .workout

    @AppStorage(DefaultItem.language.rawValue,
                store: UserDefaults(suiteName: UserDefaultValues.groupId.rawValue))
    var language: Language = .en

    @AppStorage(DefaultItem.soundsEnabled.rawValue,
                store: UserDefaults(suiteName: UserDefaultValues.groupId.rawValue))
    var soundsEnabled = true

    @AppStorage(DefaultItem.hapticsEnabled.rawValue,
                store: UserDefaults(suiteName: UserDefaultValues.groupId.rawValue))
    var hapticsEnabled = true

    @AppStorage(DefaultItem.notificationsEnabled.rawValue,
                store: UserDefaults(suiteName: UserDefaultValues.groupId.rawValue))
    var notificationsEnabled = false

    @AppStorage(DefaultItem.runInBackground.rawValue,
                store: UserDefaults(suiteName: UserDefaultValues.groupId.rawValue))
    var runInBackground = false

    @AppStorage(DefaultItem.stopWatchType.rawValue,
                store: UserDefaults(suiteName: UserDefaultValues.groupId.rawValue))
    var stopWatchType: TimerType = .stopWatch
}

struct AppStorageManager {
    var storeToUserDefaults: @Sendable (_ data: String, _ key: UserDefaultValues) -> Void
    var loadFromDefaults: @Sendable (_ key: UserDefaultValues) -> String?
    var removeFromDefaults: @Sendable (_ key: UserDefaultValues) -> Void
    var storeStringToAppStorage: @Sendable (_ data: String, _ key: DefaultItem) -> Void
    var storeBoolToAppStorage: @Sendable (_ data: Bool, _ key: DefaultItem) -> Void
    var storeSectionToAppStorage: @Sendable (_ data: Section) -> Void
    var storeLanguageToAppStorage: @Sendable (_ data: Language) -> Void
    var storeStopWatchTypeToAppStorage: @Sendable (_ data: TimerType) -> Void
    var getSelectedWorkoutId: @Sendable () -> String
    var getSelectedTrainingId: @Sendable () -> String
    var getSelectedSection: @Sendable () -> Section
    var getLanguage: @Sendable () -> Language
    var getSoundsEnabled: @Sendable () -> Bool
    var getHapticsEnabled: @Sendable () -> Bool
    var getNotificationsEnabled: @Sendable () -> Bool
    var getRunInBackground: @Sendable () -> Bool
    var getStopWatchType: @Sendable () -> TimerType
}

extension AppStorageManager: DependencyKey {
    static var liveValue = Self(
        storeToUserDefaults: { data, key in
            UserDefaults(suiteName: UserDefaultValues.groupId.rawValue)?.set(data, forKey: key.rawValue)
        },
        loadFromDefaults: { key in
            UserDefaults(suiteName: UserDefaultValues.groupId.rawValue)?.object(forKey: key.rawValue) as? String
        },
        removeFromDefaults: { key in
            UserDefaults(suiteName: UserDefaultValues.groupId.rawValue)?.removeObject(forKey: key.rawValue)
        },
        storeStringToAppStorage: { data, key in
            switch key {
            case .selectedWorkoutId:
                AppStorageValues.shared.selectedWorkoutId = data

            case .selectedTrainingId:
                AppStorageValues.shared.selectedTrainingId = data

            default:
                break
            }
        },
        storeBoolToAppStorage: { data, key in
            switch key {
            case .soundsEnabled:
                AppStorageValues.shared.soundsEnabled = data

            case .hapticsEnabled:
                AppStorageValues.shared.hapticsEnabled = data

            case .notificationsEnabled:
                AppStorageValues.shared.notificationsEnabled = data

            case .runInBackground:
                AppStorageValues.shared.runInBackground = data

            default:
                break
            }
        },
        storeSectionToAppStorage: { data in
            AppStorageValues.shared.selectedSection = data
        },
        storeLanguageToAppStorage: { data in
            AppStorageValues.shared.language = data
        },
        storeStopWatchTypeToAppStorage: { data in
            AppStorageValues.shared.stopWatchType = data
        },
        getSelectedWorkoutId: {
            AppStorageValues.shared.selectedWorkoutId
        },
        getSelectedTrainingId: {
            AppStorageValues.shared.selectedTrainingId
        },
        getSelectedSection: {
            AppStorageValues.shared.selectedSection
        },
        getLanguage: {
            AppStorageValues.shared.language
        },
        getSoundsEnabled: {
            AppStorageValues.shared.soundsEnabled
        },
        getHapticsEnabled: {
            AppStorageValues.shared.hapticsEnabled
        },
        getNotificationsEnabled: {
            AppStorageValues.shared.notificationsEnabled
        },
        getRunInBackground: {
            AppStorageValues.shared.runInBackground
        },
        getStopWatchType: {
            AppStorageValues.shared.stopWatchType
        }
    )
    static var testValue = Self(
        storeToUserDefaults: { data, key in
            var mock = AppStorageManagerMock.shared
            switch key {
            case .workoutId:
                mock.widgetWorkout = data

            case .trainingId:
                mock.widgetTraining = data

            default:
                break
            }
        },
        loadFromDefaults: { key in
            var mock = AppStorageManagerMock.shared
            switch key {
            case .workoutId:
                return mock.widgetWorkout

            case .trainingId:
                return mock.widgetTraining

            default:
                return nil
            }
        },
        removeFromDefaults: { key in
            var mock = AppStorageManagerMock.shared
            switch key {
            case .workoutId:
                mock.widgetWorkout = nil

            case .trainingId:
                mock.widgetTraining = nil

            default:
                break
            }
        },
        storeStringToAppStorage: { data, key in
            switch key {
            case .selectedWorkoutId:
                AppStorageManagerMock.shared.selectedWorkoutId = data

            case .selectedTrainingId:
                AppStorageManagerMock.shared.selectedTrainingId = data

            default:
                break
            }
        },
        storeBoolToAppStorage: { data, key in
            switch key {
            case .soundsEnabled:
                AppStorageManagerMock.shared.soundsEnabled = data

            case .hapticsEnabled:
                AppStorageManagerMock.shared.hapticsEnabled = data

            case .notificationsEnabled:
                AppStorageManagerMock.shared.notificationsEnabled = data

            case .runInBackground:
                AppStorageManagerMock.shared.runInBackground = data

            default:
                break
            }
        },
        storeSectionToAppStorage: { data in
            AppStorageManagerMock.shared.selectedSection = data
        },
        storeLanguageToAppStorage: { data in
            AppStorageManagerMock.shared.language = data
        },
        storeStopWatchTypeToAppStorage: { data in
            AppStorageManagerMock.shared.stopWatchType = data
        },
        getSelectedWorkoutId: {
            AppStorageManagerMock.shared.selectedWorkoutId
        },
        getSelectedTrainingId: {
            AppStorageManagerMock.shared.selectedTrainingId
        },
        getSelectedSection: {
            AppStorageManagerMock.shared.selectedSection
        },
        getLanguage: {
            AppStorageManagerMock.shared.language
        },
        getSoundsEnabled: {
            AppStorageManagerMock.shared.soundsEnabled
        },
        getHapticsEnabled: {
            AppStorageManagerMock.shared.hapticsEnabled
        },
        getNotificationsEnabled: {
            AppStorageManagerMock.shared.notificationsEnabled
        },
        getRunInBackground: {
            AppStorageManagerMock.shared.runInBackground
        },
        getStopWatchType: {
            AppStorageManagerMock.shared.stopWatchType
        }
    )
}
