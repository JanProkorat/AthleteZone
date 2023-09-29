//
//  WorkOutDto.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 28.09.2023.
//

import Foundation

class WorkOutDto: WorkOutProtocol, Identifiable {
    static func == (lhs: WorkOutDto, rhs: WorkOutDto) -> Bool {
        lhs.id == rhs.id
    }

    var id: String

    var name: String
    var work: Int
    var rest: Int
    var series: Int
    var rounds: Int
    var reset: Int
    var createdDate: Date
    var workoutLength: Int

    init(
        id: String,
        name: String,
        work: Int,
        rest: Int,
        series: Int,
        rounds: Int,
        reset: Int,
        createdDate: Date,
        workoutLength: Int
    ) {
        self.id = id
        self.name = name
        self.work = work
        self.rest = rest
        self.series = series
        self.rounds = rounds
        self.reset = reset
        self.createdDate = createdDate
        self.workoutLength = workoutLength
    }
}

extension WorkOutDto {
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
