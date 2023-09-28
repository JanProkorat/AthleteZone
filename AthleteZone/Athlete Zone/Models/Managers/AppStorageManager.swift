//
//  AppStorageManager.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 19.02.2023.
//

import Foundation
import SwiftUI

class AppStorageManager: ObservableObject {
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

    public func storeToUserDefaults(data: String, key: String) {
        UserDefaults(suiteName: UserDefaultValues.groupId.rawValue)!.set(data, forKey: key)
    }

    public func loadFromDefaults(key: String) -> String? {
        return UserDefaults(suiteName: UserDefaultValues.groupId.rawValue)!.object(forKey: key) as? String
    }

    public func removeFromDefaults(key: String) {
        UserDefaults(suiteName: UserDefaultValues.groupId.rawValue)?.removeObject(forKey: key)
    }
}
