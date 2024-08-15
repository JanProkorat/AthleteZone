//
//  SectionManager.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 24.08.2023.
//

import Dependencies
import Foundation
import SwiftUI

struct AppStorageValues {
    static let shared = AppStorageValues()

    @AppStorage(DefaultItem.backupData.rawValue,
                store: UserDefaults(suiteName: UserDefaultValues.groupId.rawValue))
    var backupData: String = ""

    @AppStorage(DefaultItem.hapticsEnabled.rawValue,
                store: UserDefaults(suiteName: UserDefaultValues.groupId.rawValue))
    var hapticsEnabled: Bool = true

    @AppStorage(DefaultItem.language.rawValue,
                store: UserDefaults(suiteName: UserDefaultValues.groupId.rawValue))
    var language: Language = .en
}

struct AppStorageManager {
    var storeBackUpData: @Sendable (_ data: String) -> Void
    var getBackUpData: @Sendable () -> String
    var storeHapticsEnabled: @Sendable (_ enabled: Bool) -> Void
    var getHapticsEnabled: @Sendable () -> Bool
    var storeLanguage: @Sendable (_ language: Language) -> Void
    var getLanguage: @Sendable () -> Language
}

extension AppStorageManager: DependencyKey {
    static var liveValue = Self(
        storeBackUpData: { data in
            AppStorageValues.shared.backupData = data
        },
        getBackUpData: {
            AppStorageValues.shared.backupData
        },
        storeHapticsEnabled: { enabled in
            AppStorageValues.shared.hapticsEnabled = enabled
        },
        getHapticsEnabled: {
            AppStorageValues.shared.hapticsEnabled
        },
        storeLanguage: { language in
            AppStorageValues.shared.language = language
        },
        getLanguage: {
            AppStorageValues.shared.language
        }
    )
}
