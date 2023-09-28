//
//  WidgetWorkOut.swift
//  RunningWorkoutWidgetExtension
//
//  Created by Jan Prokorát on 25.09.2023.
//

import Foundation

struct WidgetWorkOut: Codable {
    var id: String

    var name: String
    var work: Int
    var rest: Int
    var series: Int
    var rounds: Int
    var reset: Int
    var workoutLength: Int
}

extension WidgetWorkOut {
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
