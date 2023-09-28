//
//  Training.swift
//  RunningWorkoutWidgetExtension
//
//  Created by Jan Prokorát on 25.09.2023.
//

import Foundation

struct WidgetTraining: Codable {
    var id: String

    var name: String
    var trainingDescription: String
    var workoutsCount: Int
    var trainingLength: Int
}

extension WidgetTraining {
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
