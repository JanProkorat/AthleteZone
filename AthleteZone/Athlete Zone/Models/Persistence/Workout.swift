//
//  WorkOut.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 10.11.2022.
//

import Foundation
import SwiftData

@Model class Workout: Identifiable {
    @Attribute(.unique) let id = UUID()

    @Attribute(.spotlight) var name: String
    @Attribute(.spotlight) var work: Int
    @Attribute(.spotlight) var rest: Int
    @Attribute(.spotlight) var series: Int
    @Attribute(.spotlight) var rounds: Int
    @Attribute(.spotlight) var reset: Int
    @Attribute(.spotlight) var createdDate = Date()

    init() {
        name = ""
        work = 30
        rest = 60
        series = 3
        rounds = 2
        reset = 60
    }

    init(_ name: String, _ work: Int, _ rest: Int, _ series: Int, _ rounds: Int, _ reset: Int) {
        self.name = name
        self.work = work
        self.rest = rest
        self.series = series
        self.rounds = rounds
        self.reset = reset
    }

    init(_ id: UUID, _ name: String, _ work: Int, _ rest: Int, _ series: Int, _ rounds: Int, _ reset: Int) {
        self.name = name
        self.work = work
        self.rest = rest
        self.series = series
        self.rounds = rounds
        self.reset = reset
        self.id = id
    }

    var workoutLength: Int {
        (((work * series) + (rest * series) + reset) * rounds) - reset
    }

    var formattedCreatedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: createdDate)
    }
}

extension Workout {
    func toDto() -> WorkoutDto {
        return WorkoutDto(
            id: id,
            name: name,
            work: work,
            rest: rest,
            series: series,
            rounds: rounds,
            reset: reset,
            createdDate: createdDate,
            workoutLength: workoutLength
        )
    }
}
