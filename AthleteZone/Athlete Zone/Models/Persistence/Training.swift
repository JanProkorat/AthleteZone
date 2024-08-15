//
//  Training.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 23.03.2023.
//

import Foundation
import SwiftData

@Model class Training: Identifiable {
    @Attribute(.unique) let id = UUID()

    @Attribute(.spotlight) var name: String
    var trainingDescription: String
    @Attribute(.spotlight) var createdDate = Date()
    @Relationship(deleteRule: .cascade) var workouts: [WorkoutInfo]

    var workoutCount: Int {
        workouts.count
    }

    var trainingLength: Int {
        getTrainingLength()
    }

    var formattedCreatedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: createdDate)
    }

    init() {
        name = ""
        trainingDescription = ""
        workouts = []
    }

    init(name: String, description: String, workouts: [WorkoutInfo]) {
        self.name = name
        trainingDescription = description
        self.workouts = workouts
    }

    func addWorkOuts(_ workouts: [Workout]) {
        self.workouts.removeAll()
        self.workouts = workouts.map { WorkoutInfo(workoutId: $0.id, workoutLength: $0.workoutLength) }
    }

    private func getTrainingLength() -> Int {
        var result = 0
        for workout in workouts {
            result += workout.workoutLength
        }
        return result
    }
}

extension Training {
    func toDto() -> TrainingDto {
        return TrainingDto(
            id: id.uuidString,
            name: name,
            trainingDescription: trainingDescription,
            workoutsCount: workouts.count,
            trainingLength: trainingLength,
            createdDate: createdDate,
            workouts: []
        )
    }

    func toDto(workouts: [WorkoutDto]) -> TrainingDto {
        return TrainingDto(
            id: id.uuidString,
            name: name,
            trainingDescription: trainingDescription,
            workoutsCount: workouts.count,
            trainingLength: trainingLength,
            createdDate: createdDate,
            workouts: workouts
        )
    }
}

struct WorkoutInfo: Codable {
    var id = UUID()
    var workoutId: UUID
    var workoutLength: Int
}
