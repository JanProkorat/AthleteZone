//
//  WorkoutRunTab.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 17.05.2024.
//

import ComposableArchitecture
import SwiftUI

struct WorkoutRunTab: View {
    @Bindable var store: StoreOf<WorkoutRunFeature>

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
    WorkoutRunTab(store: ComposableArchitecture.Store(initialState: WorkoutRunFeature.State(workout: WorkoutDto(
        id: UUID(),
        name: "Druhy",
        work: 3,
        rest: 3,
        series: 3,
        rounds: 3,
        reset: 30,
        createdDate: Date(),
        workoutLength: 12250
    ))) {
        WorkoutRunFeature()
            ._printChanges()
    })
}
