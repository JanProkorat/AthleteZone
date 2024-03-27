//
//  BackUpDto.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 25.11.2023.
//

import Foundation

struct BackUpDto: Codable {
    var workouts: [WorkoutDto] = []
    var trainings: [TrainingDto] = []
    var currentSection: Section = .workout
    var currentLanguage: Language = .en
    var soundsEnabled: Bool = false
    var hapticsEnabled: Bool = false

    func encode() -> String {
        do {
            let encodedData = try JSONEncoder().encode(self)
            let jsonString = String(data: encodedData, encoding: .utf8)
            return jsonString ?? ""
        } catch {
            print(error)
            return ""
        }
    }
}
