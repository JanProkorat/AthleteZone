//
//  WorkoutLibraryTab.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 24.08.2023.
//

import SwiftUI

struct WorkoutLibraryTab: View {
    var library: [WorkoutDto]
    var selectedId: UUID
    var onWorkoutSelect: ((_ workout: WorkoutDto) -> Void)?

    var body: some View {
        VStack {
            ScrollView {
                ForEach(library) { workout in
                    Button {
                        performAction(onWorkoutSelect, value: workout)
                    } label: {
                        HStack {
                            Text(workout.name)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 10)
                                .font(.footnote)
                                .lineLimit(2)
                                .foregroundStyle(workout.id == selectedId ? Color(ComponentColor.darkGrey.rawValue) : .white)

                            Text(workout.workoutLength.toFormattedTime())
                                .padding(.trailing, 10)
                                .font(.caption)
                                .foregroundStyle(workout.id == selectedId ? Color(ComponentColor.darkGrey.rawValue) : .white)
                        }
                        .padding([.top, .bottom], 12)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .roundedBackground(cornerRadius: 10, color: workout.id == selectedId ? .white : Color(ComponentColor.darkGrey.rawValue))
                    .padding(.top, 2)
                }
            }
            .frame(maxHeight: .infinity)
            .padding([.leading, .trailing], 5)
        }
        .padding(.top, 15)
    }
}

extension WorkoutLibraryTab {
    func onWorkoutSelect(_ handler: @escaping (_ workout: WorkoutDto) -> Void) -> WorkoutLibraryTab {
        var new = self
        new.onWorkoutSelect = handler
        return new
    }
}

#Preview {
    let id = UUID()
    return WorkoutLibraryTab(library: [WorkoutDto(
            id: id,
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
            name: "Prvni",
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
            name: "Ctvrty",
            work: 3,
            rest: 3,
            series: 3,
            rounds: 3,
            reset: 30,
            createdDate: Date(),
            workoutLength: 50
        )], selectedId: id)
}
