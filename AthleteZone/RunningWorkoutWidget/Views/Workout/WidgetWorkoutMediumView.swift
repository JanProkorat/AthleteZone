//
//  WidgetWorkoutView.swift
//  RunningWorkoutWidgetExtension
//
//  Created by Jan Prokorát on 25.09.2023.
//

import SwiftUI
import WidgetKit

struct WidgetWorkoutMediumView: View {
    var workout: WidgetWorkOut

    var body: some View {
        HStack {
            HStack {
                VStack {
                    HeaderText(text: workout.name)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading)

                    DescriptionBar(text: "Work: \(workout.work.toFormattedTime())", color: .pink)
                    DescriptionBar(text: "Rest: \(workout.rest.toFormattedTime())", color: .yellow)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            HStack {
                VStack {
                    HeaderText(text: workout.workoutLength.toFormattedTime())
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.trailing)

                    DescriptionBar(text: "Series: \(workout.series.toFormattedNumber())", color: .lightBlue)
                    DescriptionBar(text: "Rounds: \(workout.rounds.toFormattedNumber())", color: .lightGreen)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    WidgetWorkoutMediumView(
        workout: WidgetWorkOut(
            id: "sadsdsa",
            name: "Test",
            work: 30,
            rest: 15,
            series: 2,
            rounds: 4,
            reset: 60,
            workoutLength: 40
        )
    )
    .previewContext(WidgetPreviewContext(family: .systemMedium))
}
