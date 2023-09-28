//
//  WidgetWorkoutLargeView.swift
//  RunningWorkoutWidgetExtension
//
//  Created by Jan Prokorát on 26.09.2023.
//

import SwiftUI

struct WidgetWorkoutLargeView: View {
    var workout: WidgetWorkOut

    var body: some View {
        VStack {
            HStack {
                HeaderText(text: workout.name)
                    .font(.largeTitle)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)

                HeaderText(text: workout.workoutLength.toFormattedTime())
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing)
            }

            ActivityBar(
                icon: "play.circle",
                text: ActivityType.work.rawValue,
                interval: workout.work.toFormattedTime(),
                color: .pink
            )

            ActivityBar(
                icon: "pause.circle",
                text: ActivityType.rest.rawValue,
                interval: workout.rest.toFormattedTime(),
                color: .yellow
            )

            ActivityBar(
                icon: "forward.circle",
                text: ActivityType.series.rawValue,
                interval: workout.series.toFormattedNumber(),
                color: .lightBlue
            )

            ActivityBar(
                icon: "repeat.circle",
                text: ActivityType.rounds.rawValue,
                interval: workout.rounds.toFormattedNumber(),
                color: .lightGreen
            )

            ActivityBar(
                icon: "clock.arrow.circlepath",
                text: ActivityType.reset.rawValue,
                interval: workout.reset.toFormattedTime(),
                color: .braun
            )
        }
    }
}

#Preview {
    WidgetWorkoutLargeView(
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
}
