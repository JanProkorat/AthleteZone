//
//  WorkoutRunView.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 16.05.2024.
//

import ComposableArchitecture
import SwiftUI

struct WorkoutRunView: View {
    @Bindable var store: StoreOf<WorkoutRunFeature>

    var body: some View {
        NavigationView {
            TabView(selection: $store.selectedTab.sending(\.selectedTabChanged)) {
                WorkoutRunTab(store: store)
                    .tag(0)

                ActionsView(
                    isFirstRunning: store.isFirstRunning,
                    isLastRunning: store.isLastRunning,
                    state: store.state
                )
                .onBackTap {
                    store.send(.backTapped, animation: .default)
                    store.send(.selectedTabChanged(0), animation: .default)
                }
                .onForwardTap {
                    store.send(.forwardTapped, animation: .default)
                    store.send(.selectedTabChanged(0), animation: .default)
                }
                .onPauseTap {
                    store.send(.pauseTapped, animation: .default)
                    store.send(.selectedTabChanged(0), animation: .default)
                }
                .onQuitTap {
                    store.send(.quitTapped)
                }
                .tag(1)
            }
            .padding([.leading, .trailing], 5)
            .sheet(item: $store.activityResult.sending(\.activityResultChanged)) { result in
                ActivityResultView(data: result)
            }
        }
        .navigationTitle(store.state == .paused ? LocalizationKey.paused.localizedKey : LocalizedStringKey(store.workout.name))
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            store.send(.onAppear)
        }
    }
}

#Preview {
    WorkoutRunView(store: ComposableArchitecture.Store(initialState: WorkoutRunFeature.State(workout: WorkoutDto(
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
