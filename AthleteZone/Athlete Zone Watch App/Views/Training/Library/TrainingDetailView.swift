//
//  TrainingDetailView.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 14.08.2024.
//

import SwiftUI

struct TrainingDetailView: View {
    var training: TrainingDto

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    TrainingDetailView(training: TrainingDto(
        id: "sdas",
        name: "Test",
        trainingDescription: "description",
        workoutsCount: 3,
        trainingLength: 145,
        createdDate: Date(),
        workouts: [
            WorkoutDto(
                id: UUID(),
                name: "Test",
                work: 30,
                rest: 15,
                series: 2,
                rounds: 4,
                reset: 60,
                createdDate: Date(),
                workoutLength: 40
            ),
            WorkoutDto(
                id: UUID(),
                name: "qwer",
                work: 35,
                rest: 20,
                series: 3,
                rounds: 5,
                reset: 60,
                createdDate: Date(),
                workoutLength: 40
            )
        ]
    ))
}
