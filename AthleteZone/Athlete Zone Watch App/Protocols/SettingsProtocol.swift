//
//  SectionProtocol.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 22.11.2023.
//

import Foundation

protocol SettingsProtocol: ObservableObject {
    var currentSection: Section { get set }
    var currentLanguage: Language { get set }
    var soundsEnabled: Bool { get set }
    var hapticsEnabled: Bool { get set }

    var currentSectionPublished: Published<Section>.Publisher { get }
//
//    func backupData(_ workouts: [WorkoutDto], _ trainings: [TrainingDto])
//    func loadBackupData() -> BackUpDto?
}
