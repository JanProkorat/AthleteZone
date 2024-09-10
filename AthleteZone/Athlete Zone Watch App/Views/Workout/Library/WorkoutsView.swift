//
//  WorkoutsView.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 14.05.2024.
//

import ComposableArchitecture
import SwiftUI

struct WorkoutsView: View {
    @Bindable var store: StoreOf<WorkoutsFeature>

    var body: some View {
        NavigationView {
            List {
                ForEach(store.workouts, id: \.id) { workout in
                    NavigationLink(state: ContentFeature.Path.State.workoutRun(
                        WorkoutRunFeature.State(workout: workout)))
                    {
                        HStack {
                            VStack {
                                Text(workout.name)
                                    .font(.title3)
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                Text(workout.workoutLength.toFormattedTime())
                                    .font(.caption2)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading, 5)
                                    .italic()
                            }
                            .frame(maxWidth: .infinity)
                            .padding([.leading, .trailing], 5)

                            Image(systemName: "info.circle")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 23, height: 23)
                                .padding(.trailing)
                                .foregroundStyle(Color(ComponentColor.buttonGreen.rawValue))
                                .onTapGesture {
                                    store.send(.workoutSelected(workout))
                                }
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .padding([.leading, .trailing], 5)
            .padding(.top, 20)
        }
        .sheet(item: $store.selectedWorkout.sending(\.workoutSelected)) { workout in
            WorkoutDetailView(workout: workout)
        }
    }
}

#Preview {
    WorkoutsView(store: ComposableArchitecture.Store(initialState: WorkoutsFeature.State(workouts: [
        WorkoutDto(
            id: UUID(),
            name: "Druhy",
            work: 3,
            rest: 3,
            series: 3,
            rounds: 3,
            reset: 30,
            createdDate: Date(),
            workoutLength: 12250
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
    ])) {
        WorkoutsFeature()
            ._printChanges()
    })
}
