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

    @AppStorage(DefaultItem.selectedWorkoutId.rawValue) var selectedWorkoutId: String = ""
    @AppStorage(DefaultItem.selectedTrainingId.rawValue) var selectedTrainingId: String = ""
    @AppStorage(DefaultItem.selectedSection.rawValue) var selectedSection: Section = .workout
    @AppStorage(DefaultItem.language.rawValue) var language: Language = .en
    @AppStorage(DefaultItem.soundsEnabled.rawValue) var soundsEnabled = true
    @AppStorage(DefaultItem.hapticsEnabled.rawValue) var hapticsEnabled = true
    @AppStorage(DefaultItem.notificationsEnabled.rawValue) var notificationsEnabled = false
}
