//
//  SectionManager.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 24.08.2023.
//

import Foundation
import SwiftUI

class SettingsManager: SettingsProtocol {
    static var shared = SettingsManager()

    @Published var currentSection: Section = .workout
    @Published var currentLanguage: Language = .en
    @Published var soundsEnabled: Bool = false
    @Published var hapticsEnabled: Bool = false

    var currentSectionPublished: Published<Section>.Publisher { $currentSection }

    @AppStorage(DefaultItem.backupData.rawValue,
                store: UserDefaults(suiteName: UserDefaultValues.groupId.rawValue))
    var backupData: String = ""

//    func backupData(_ workouts: [WorkoutDto], _ trainings: [TrainingDto]) {
//        let backup = BackUpDto(
//            workouts: workouts,
//            trainings: trainings,
//            currentLanguage: currentLanguage,
//            soundsEnabled: soundsEnabled,
//            hapticsEnabled: hapticsEnabled
//        )
//
//        backupData = backup.encode()
//    }
//
//    func loadBackupData() -> BackUpDto? {
//        do {
//            return try backupData.decode<BackUpDto>()
//        } catch {
//            print(error.localizedDescription)
//            return nil
//        }
//    }
}
