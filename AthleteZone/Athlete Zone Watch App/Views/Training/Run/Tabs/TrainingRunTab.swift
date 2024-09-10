//
//  TrainingRunTab.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 23.05.2024.
//

import ComposableArchitecture
import SwiftUI

struct TrainingRunTab: View {
    @Bindable var store: StoreOf<TrainingRunFeature>

    var body: some View {
        if let flow = store.currentActivity {
            TimelineView(.periodic(from: .now, by: 0.5)) { _ in
                TabView {
                    WorkoutTrackingView(
                        flow: flow,
                        isFirstRunning: store.isFirstRunning,
                        isLastRunning: store.isLastRunning
                    )
                    .onBackTap { store.send(.backTapped) }
                    .onForwardTap { store.send(.forwardTapped) }

                    if let healthStore = store.scope(state: \.healthDestination?.health, action: \.healthDestination.health) {
                        HealthView(store: healthStore)
                    }
                }
                .tabViewStyle(.verticalPage)
            }
        }
    }
}

#Preview {
    TrainingRunTab(store: ComposableArchitecture.Store(initialState: TrainingRunFeature.State(training: TrainingDto(
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
