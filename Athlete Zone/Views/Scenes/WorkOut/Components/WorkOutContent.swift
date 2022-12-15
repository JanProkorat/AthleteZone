//
//  ExerciseContent.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 07.11.2022.
//

import SwiftUI

struct WorkOutContent: View {
    @EnvironmentObject var router: ViewRouter

    var work = 0
    var rest = 0
    var series = 0
    var rounds = 0
    var reset = 0

    private var timeOverview: Int {
        ((work * series) + (rest * (series - 1)) + reset) * rounds
    }

    init(_ work: Int, _ rest: Int, _ series: Int, _ rounds: Int, _ reset: Int) {
        self.work = work
        self.rest = rest
        self.series = series
        self.rounds = rounds
        self.reset = reset
    }

    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            ActivityButton(
                innerComponent: ActivityView(
                    image: Icons.Play,
                    color: Colors.Work,
                    activity: "Work",
                    interval: work,
                    type: .time
                )
            )
            .onTab { router.setActiveHomeSheet(.work) }
            .padding(.top, 5)

            ActivityButton(
                innerComponent: ActivityView(
                    image: Icons.Pause,
                    color: Colors.Rest,
                    activity: "Rest",
                    interval: rest,
                    type: .time
                )
            )
            .onTab { router.setActiveHomeSheet(.rest) }

            ActivityButton(
                innerComponent: ActivityView(
                    image: Icons.Forward,
                    color: Colors.Series,
                    activity: "Series",
                    interval: series,
                    type: .number
                )
            )
            .onTab { router.setActiveHomeSheet(.series) }

            ActivityButton(
                innerComponent: ActivityView(
                    image: Icons.Repeat,
                    color: Colors.Rounds,
                    activity: "Rounds",
                    interval: rounds,
                    type: .number
                )
            )
            .onTab { router.setActiveHomeSheet(.rounds) }

            ActivityButton(
                innerComponent: ActivityView(
                    image: Icons.Time,
                    color: Colors.Reset,
                    activity: "ResetTime",
                    interval: reset,
                    type: .time
                )
            )
            .onTab { router.setActiveHomeSheet(.reset) }

            GeometryReader { geometry in
                VStack(alignment: .center, spacing: 5) {
                    HStack(alignment: .center) {
                        Text(timeOverview.toFormattedTime())
                            .scaledToFill()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .font(.custom("Lato-Black", size: geometry.size.height * 0.25))
                    }
                    .frame(maxWidth: .infinity, maxHeight: geometry.size.height * 0.5)
                    IconButton(
                        id: "startWorkout",
                        image: Icons.Start,
                        color: Colors.Action,
                        width: geometry.size.height * 0.5,
                        height: geometry.size.height * 0.5
                    )
                    .onTab {
                        self.router.currentTab = .exerciseRun
                    }
                    .padding(.bottom)
                }
            }
        }
    }
}

struct ExerciseContent_Previews: PreviewProvider {
    static var previews: some View {
        WorkOutContent(40, 60, 3, 2, 60)
            .environmentObject(WorkOutViewModel())
            .environmentObject(ViewRouter())
    }
}
