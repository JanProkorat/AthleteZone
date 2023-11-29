//
//  WidgetTrainingLargeView.swift
//  RunningWorkoutWidgetExtension
//
//  Created by Jan Prokorát on 26.09.2023.
//

import SwiftUI
import WidgetKit

struct WidgetTrainingLargeView: View {
    var training: TrainingDto

    var body: some View {
        VStack {
            HeaderText(text: training.name)
                .frame(maxWidth: .infinity)

            Spacer()

            Text(training.trainingDescription)
                .foregroundColor(Color(ComponentColor.lightBlue.rawValue))
                .font(.headline)
                .padding([.leading, .trailing])
                .fixedSize(horizontal: false, vertical: true)
                .lineLimit(7)
                .frame(maxWidth: .infinity)
                .background(
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(height: 140)
                            .foregroundColor(Color(ComponentColor.darkGrey.rawValue))
                    }
                )

            Spacer()

            ActivityBar(
                icon: "figure.run.circle",
                text: "Workouts",
                interval: training.workoutsCount.toFormattedNumber(),
                color: .lightGreen
            )

            ActivityBar(
                icon: "figure.run.circle",
                text: "Length",
                interval: training.trainingLength.toFormattedTime(),
                color: .lightPink
            )
        }
        Spacer()
    }
}

#Preview {
    WidgetTrainingLargeView(
        training: TrainingDto(
            id: "sdas",
            name: "Test",
            trainingDescription: "description",
            workoutsCount: 3,
            trainingLength: 145,
            createdDate: Date(),
            workouts: [
                WorkOutDto(
                    id: "sadsdsa",
                    name: "Test",
                    work: 30,
                    rest: 15,
                    series: 2,
                    rounds: 4,
                    reset: 60,
                    createdDate: Date(),
                    workoutLength: 40
                ),
                WorkOutDto(
                    id: "zxczx",
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
        )
    )
    .previewContext(WidgetPreviewContext(family: .systemMedium))
}
