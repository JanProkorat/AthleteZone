//
//  AppStorageManager.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 19.02.2023.
//

import Foundation
import SwiftUI

class AppStorageManager: AppStorageProtocol {
    static let shared = AppStorageManager()

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

    public func storeToUserDefaults(data: String, key: UserDefaultValues) {
        UserDefaults(suiteName: UserDefaultValues.groupId.rawValue)?.set(data, forKey: key.rawValue)
    }

    public func loadFromDefaults(key: UserDefaultValues) -> String? {
        return UserDefaults(suiteName: UserDefaultValues.groupId.rawValue)?.object(forKey: key.rawValue) as? String
    }

    public func removeFromDefaults(key: UserDefaultValues) {
        UserDefaults(suiteName: UserDefaultValues.groupId.rawValue)?.removeObject(forKey: key.rawValue)
    }
}
