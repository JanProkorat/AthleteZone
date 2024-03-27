//
//  WorkoutPicker.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 11.07.2023.
//

import SwiftUI

struct WorkoutPicker: View {
    @Binding var workouts: [WorkoutDto]
    var workoutsLibrary: [WorkoutDto]

    var onCloseTab: (() -> Void)?

    var body: some View {
        DetailBaseView(title: LocalizedStringKey(LocalizationKey.selectWorkouts.rawValue)) {
            List(workoutsLibrary, id: \.id) { workout in
                Button {
                    if let index = workouts.firstIndex(where: { $0.id == workout.id }) {
                        workouts.remove(at: index)
                    } else {
                        workouts.append(workout)
                    }
                } label: {
                    listItem(item: workout)
                }
                .padding(.bottom, 130)
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                .background(Color(ComponentColor.darkBlue.rawValue))
            }
            .listStyle(.plain)
            .padding([.top, .bottom], 5)
            .overlay(alignment: .top) {
                if workoutsLibrary.isEmpty {
                    Text(LocalizationKey.noWorkoutsToDisplay.localizedKey)
                        .font(.headline)
                        .bold()
                        .padding(.top, 30)
                }
            }
        }
        .onCloseTab {
            performAction(onCloseTab)
        }
    }

    @ViewBuilder
    func listItem(item: WorkoutDto) -> some View {
        WorkoutPickerItem(
            workout: item,
            isSelected: workouts.contains(item)
        )
        .padding([.leading, .trailing], 2)
        .id(item.id)
    }
}

struct WorkoutPicker_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutPicker(workouts: Binding.constant([]), workoutsLibrary: [
            WorkoutDto(
                id: "2",
                name: "Druhy",
                work: 3,
                rest: 3,
                series: 3,
                rounds: 3,
                reset: 30,
                createdDate: Date(),
                workoutLength: 50
            ),
            WorkoutDto(
                id: "3",
                name: "Treti",
                work: 2,
                rest: 2,
                series: 2,
                rounds: 2,
                reset: 30,
                createdDate: Date(),
                workoutLength: 50
            ),
            WorkoutDto(
                id: "2",
                name: "Druhy",
                work: 3,
                rest: 3,
                series: 3,
                rounds: 3,
                reset: 30,
                createdDate: Date(),
                workoutLength: 50
            ),
            WorkoutDto(
                id: "3",
                name: "Treti",
                work: 2,
                rest: 2,
                series: 2,
                rounds: 2,
                reset: 30,
                createdDate: Date(),
                workoutLength: 50
            ),
            WorkoutDto(
                id: "2",
                name: "Druhy",
                work: 3,
                rest: 3,
                series: 3,
                rounds: 3,
                reset: 30,
                createdDate: Date(),
                workoutLength: 50
            ),
            WorkoutDto(
                id: "3",
                name: "Treti",
                work: 2,
                rest: 2,
                series: 2,
                rounds: 2,
                reset: 30,
                createdDate: Date(),
                workoutLength: 50
            )
        ])
    }
}

extension WorkoutPicker {
    func onCloseTab(_ handler: @escaping () -> Void) -> WorkoutPicker {
        var new = self
        new.onCloseTab = handler
        return new
    }
}
