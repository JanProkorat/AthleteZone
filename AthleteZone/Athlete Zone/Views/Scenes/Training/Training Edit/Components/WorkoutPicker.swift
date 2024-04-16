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
    @State var workoutForDetail: WorkoutDto?

    var body: some View {
        DetailBaseView(title: LocalizedStringKey(LocalizationKey.selectWorkouts.rawValue)) {
            GeometryReader { geo in
                VStack {
                    Text(LocalizationKey.library.localizedKey)
                        .font(.title2)

                    Divider()
                        .overlay(Color.white)

                    List(workoutsLibrary, id: \.id) { workout in
                        Button {
                            workoutForDetail = workout
                        } label: {
                            HStack {
                                Text(workout.name)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(.title3)

                                Text(workout.workoutLength.toFormattedTime())
                                    .font(.title3)
                                    .padding(.leading)

                                Button {
                                    workouts.append(workout)
                                } label: {
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundColor(Color(ComponentColor.lightGreen.rawValue))
                                        .font(.title2)
                                }
                                .padding(.leading)
                            }
                            .padding(8)
                            .roundedBackground(cornerRadius: 10, color: ComponentColor.menu)
                            .frame(maxWidth: .infinity)
                            .background(Color(ComponentColor.darkBlue.rawValue))
                        }
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    }
                    .listStyle(.plain)
                    .padding([.top, .bottom], 5)
                    .frame(maxHeight: geo.size.height * 0.4)
                    .overlay(alignment: .top) {
                        if workoutsLibrary.isEmpty {
                            Text(LocalizationKey.noWorkoutsToDisplay.localizedKey)
                                .font(.headline)
                                .bold()
                                .padding(.top, 30)
                        }
                    }

                    Text(LocalizationKey.workoutsInTraining.localizedKey)
                        .font(.title2)

                    Divider()
                        .overlay(Color.white)

                    List(workouts.indices, id: \.self) { index in
                        Button {
                            workoutForDetail = workouts[index]
                        } label: {
                            HStack {
                                Text(workouts[index].name)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(.title3)

                                Text(workouts[index].workoutLength.toFormattedTime())
                                    .font(.title3)
                                    .padding(.leading)

                                Button {
                                    workouts.remove(at: index)
                                } label: {
                                    Image(systemName: "minus.circle.fill")
                                        .foregroundColor(Color(ComponentColor.lightPink.rawValue))
                                        .font(.title2)
                                }
                                .padding(.leading)
                            }
                            .padding(8)
                            .roundedBackground(cornerRadius: 10, color: ComponentColor.menu)
                            .frame(maxWidth: .infinity)
                            .background(Color(ComponentColor.darkBlue.rawValue))
                        }
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    }
                    .listStyle(.plain)
                    .padding([.top, .bottom], 5)
                    .frame(maxHeight: geo.size.height * 0.4)
                    .overlay(alignment: .top) {
                        if workouts.isEmpty {
                            Text(LocalizationKey.noWorkoutsToDisplay.localizedKey)
                                .font(.headline)
                                .bold()
                                .padding(.top, 30)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .onCloseTab {
            performAction(onCloseTab)
        }
        .sheet(item: $workoutForDetail) { _ in
            WorkoutDetailSheet(workout: $workoutForDetail)
                .presentationDetents([.fraction(0.4)])
        }
    }
}

struct WorkoutPicker_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutPicker(workouts: Binding.constant([]), workoutsLibrary: [
            WorkoutDto(
                id: UUID(),
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
                id: UUID(),
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
                id: UUID(),
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
                id: UUID(),
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
                id: UUID(),
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
                id: UUID(),
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
