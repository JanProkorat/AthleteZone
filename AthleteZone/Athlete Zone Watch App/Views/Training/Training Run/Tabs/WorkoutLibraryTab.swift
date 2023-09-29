//
//  WorkoutLibraryTab.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 24.08.2023.
//

import SwiftUI

struct WorkoutLibraryTab: View {
    @EnvironmentObject var viewModel: WatchWorkOutRunViewModel
    var onWorkoutSelect: (() -> Void)?

    var body: some View {
        BaseView(title: "Workouts") {
            VStack {
                List(viewModel.workoutLibrary, id: \.id) { workout in
                    Button {
                        viewModel.nextWorkout = workout
                        viewModel.setState(.finished)
                        performAction(onWorkoutSelect)
                    } label: {
                        ListItemView(name: workout.name, workOutTime: workout.workoutLength.toFormattedTime())
                    }
                    .listRowInsets(EdgeInsets(top: 2, leading: 2, bottom: 0, trailing: 2))
                }
                .listStyle(PlainListStyle())
                .environment(\.defaultMinListRowHeight, 50)

                HStack {}
                    .frame(height: 10)
                    .frame(maxWidth: .infinity)
                    .background(Color(ComponentColor.darkBlue.rawValue))
                    .padding(.bottom)
            }
        }
    }
}

struct WorkoutLibraryTab_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutLibraryTab()
            .environmentObject(
                WatchWorkOutRunViewModel()
            )
    }
}

extension WorkoutLibraryTab {
    func onWorkoutSelect(_ handler: @escaping () -> Void) -> WorkoutLibraryTab {
        var new = self
        new.onWorkoutSelect = handler
        return new
    }
}
