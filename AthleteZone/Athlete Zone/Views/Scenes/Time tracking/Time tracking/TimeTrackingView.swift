//
//  TimeTrackingView.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 04.03.2024.
//

import ComposableArchitecture
import SwiftUI

struct TimeTrackingView: View {
    @Bindable var store: StoreOf<TimeTrackingFeature>

    var body: some View {
        VStack {
            switch store.displayedType {
            case .stopWatch:
                StopWatchView(
                    interval: store.lastActivity?.interval ?? 0,
                    splitTimes: store.lastActivity?.splitTimes ?? []
                )
                .onStartTap { store.send(.startTapped()) }

            case .timer:
                TimerView(
                    interval: $store.timerStartValue.sending(\.timerStartValueChanged),
                    recent: store.recentTimers
                )
                    .onStartTap { store.send(.startTapped()) }
                    .onRecentStartTap { interval in
                        store.send(.startTapped(interval))
                    }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .fullScreenCover(item: $store.scope(state: \.destination?.runStopwatchSheet, action: \.destination.runStopwatchSheet)) { store in
            StopwatchRunView(store: store)
        }
        .fullScreenCover(item: $store.scope(state: \.destination?.runTimerSheet, action: \.destination.runTimerSheet)) { store in
            TimerRunView(store: store)
        }
    }
}

#Preview {
    TimeTrackingView(store: ComposableArchitecture.Store(initialState: TimeTrackingFeature.State(), reducer: {
        TimeTrackingFeature()
    }))
}
