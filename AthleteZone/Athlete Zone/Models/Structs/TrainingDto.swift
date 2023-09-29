//
//  TrainingDto.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 28.09.2023.
//

import Foundation

struct TrainingDto: Codable, Identifiable {
    var id: String

    var name: String
    var trainingDescription: String
    var workoutsCount: Int
    var trainingLength: Int
    var createdDate: Date
    var workouts: [WorkOutDto]
}

extension TrainingDto {
    func encode() -> String? {
        do {
            let encodedData = try JSONEncoder().encode(self)
            let jsonString = String(data: encodedData, encoding: .utf8)
            return jsonString
        } catch {
            print(error)
            return nil
        }
    }
}
