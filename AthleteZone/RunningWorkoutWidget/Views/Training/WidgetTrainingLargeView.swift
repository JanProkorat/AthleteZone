//
//  WidgetTrainingLargeView.swift
//  RunningWorkoutWidgetExtension
//
//  Created by Jan Prokorát on 26.09.2023.
//

import SwiftUI
import WidgetKit

struct WidgetTrainingLargeView: View {
    var training: WidgetTraining

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
                            .foregroundColor(Color(Background.listItemBackground.rawValue))
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
                color: .pink
            )
        }
        Spacer()
    }
}

#Preview {
    WidgetTrainingLargeView(
        training: WidgetTraining(
            id: "sdas",
            name: "Test",
            trainingDescription: "description",
            workoutsCount: 3,
            trainingLength: 145
        )
    )
    .previewContext(WidgetPreviewContext(family: .systemMedium))
}
