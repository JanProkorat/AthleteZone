//
//  TrainingRunView.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 16.05.2024.
//

import ComposableArchitecture
import SwiftUI

struct TrainingRunView: View {
    @Bindable var store: StoreOf<TrainingRunFeature>

    var body: some View {
        NavigationView {
            TabView(selection: $store.selectedTab.sending(\.selectedTabChanged)) {
                WorkoutLibraryTab(library: store.training.workouts, selectedId: store.currentWorkout?.id ?? UUID())
                    .onWorkoutSelect { workout in
                        store.send(.setWorkflow(workout), animation: .default)
                        store.send(.stateChanged(.paused), animation: .default)
                        store.send(.selectedTabChanged(1), animation: .default)
                    }
                    .tag(0)

                TrainingRunTab(store: store)
                    .tag(1)

                ActionsView(
                    isFirstRunning: store.isFirstRunning,
                    isLastRunning: store.isLastRunning,
                    state: store.state
                )
                .onBackTap {
                    store.send(.backTapped, animation: .default)
                    store.send(.selectedTabChanged(1), animation: .default)
                }
                .onForwardTap {
                    store.send(.forwardTapped, animation: .default)
                    store.send(.selectedTabChanged(1), animation: .default)
                }
                .onPauseTap {
                    store.send(.pauseTapped, animation: .default)
                    store.send(.selectedTabChanged(1), animation: .default)
                }
                .onQuitTap {
                    store.send(.quitTapped)
                }
                .tag(2)
            }
            .padding([.leading, .trailing], 5)
            .sheet(item: $store.activityResult.sending(\.activityResultChanged)) { result in
                ActivityResultView(data: result)
            }
        }
        .navigationTitle(store.state == .paused ? LocalizationKey.paused.localizedKey : LocalizedStringKey(store.currentWorkout?.name ?? ""))
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            store.send(.onAppear)
        }
    }
}

#Preview {
    TrainingRunView(store: ComposableArchitecture.Store(initialState: TrainingRunFeature.State(training: TrainingDto(
        id: "1",
        name: "Name",
        trainingDescription: "description",
        workoutsCount: 5,
        trainingLength: 3600,
        createdDate: Date(),
        workouts: [WorkoutDto(
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
            name: "Prvni",
            work: 2,
            rest: 2,
            series: 2,
            rounds: 2,
            reset: 30,
            createdDate: Date(),
            workoutLength: 50
        )]
    ))) {
        TrainingRunFeature()
            ._printChanges()
    })
}
