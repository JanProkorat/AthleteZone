//
//  TimerRunTab.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 16.07.2024.
//

import ComposableArchitecture
import SwiftUI

struct TimerRunTab: View {
    @Bindable var store: StoreOf<TimerRunFeature>

    var body: some View {
        TabView {
            TimerTrackingTab(
                originalTime: store.startTime,
                actionLabel: store.actionLabel,
                timeElapsed: store.timeRemaining.toFormattedTimeForWorkout(),
                actionColor: store.actionColor)

            if let healthStore = store.scope(state: \.healthDestination?.health, action: \.healthDestination.health) {
                HealthView(store: healthStore)
            }
        }
        .tabViewStyle(.verticalPage)
        .id("vertical")
    }
}

#Preview {
    TimerRunTab(store: ComposableArchitecture.Store(initialState: TimerRunFeature.State()) {
        TimerRunFeature()
            ._printChanges()
    })
}
