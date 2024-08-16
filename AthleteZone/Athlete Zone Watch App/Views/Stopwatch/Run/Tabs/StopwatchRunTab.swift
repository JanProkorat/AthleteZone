//
//  StopwatchRunTab.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 05.07.2024.
//

import ComposableArchitecture
import SwiftUI

struct StopwatchRunTab: View {
    @Bindable var store: StoreOf<StopwatchRunFeature>

    var body: some View {
        TabView {
            StopwatchTrackingTab(
                timeElapsed: store.formatedTime,
                splitTime: store.splitTimes.last,
                state: store.state,
                actionLabel: store.actionLabel,
                actionColor: store.actionColor,
                isFirstRunning: store.isFirstRunning,
                isLastRunning: store.isLastRunning)
                .onAddSplitTimeTab { store.send(.addSplitTime) }
                .onBackTap { store.send(.backTapped) }
                .onForwardTap { store.send(.forwardTapped) }

            if let healthStore = store.scope(state: \.healthDestination?.health, action: \.healthDestination.health) {
                HealthView(store: healthStore)
            }
        }
        .tabViewStyle(.verticalPage)
        .id("vertical")
    }
}

#Preview {
    StopwatchRunTab(store: ComposableArchitecture.Store(initialState: StopwatchRunFeature.State()) {
        StopwatchRunFeature()
            ._printChanges()
    })
}
