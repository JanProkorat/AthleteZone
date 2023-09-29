//
//  DefaultLargeView.swift
//  RunningWorkoutWidgetExtension
//
//  Created by Jan Prokorát on 26.09.2023.
//

import SwiftUI

struct DefaultLargeView: View {
    var body: some View {
        VStack {
            HStack {
                HeaderText(text: "Athlete Zone")
                    .font(.largeTitle)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)

                HeaderText(text: "__:__")
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing)
            }

            ActivityBar(
                icon: "play.circle",
                text: ActivityType.work.rawValue,
                interval: "__:__",
                color: .lightPink
            )

            ActivityBar(
                icon: "pause.circle",
                text: ActivityType.rest.rawValue,
                interval: "__:__",
                color: .lightYellow
            )

            ActivityBar(
                icon: "forward.circle",
                text: ActivityType.series.rawValue,
                interval: "_",
                color: .lightBlue
            )

            ActivityBar(
                icon: "repeat.circle",
                text: ActivityType.rounds.rawValue,
                interval: "_",
                color: .lightGreen
            )

            ActivityBar(
                icon: "clock.arrow.circlepath",
                text: ActivityType.reset.rawValue,
                interval: "__:__",
                color: .braun
            )
        }
    }
}

#Preview {
    DefaultLargeView()
}
