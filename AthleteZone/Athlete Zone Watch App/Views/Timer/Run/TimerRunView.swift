//
//  TimerRunView.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 02.07.2024.
//

import ComposableArchitecture
import SwiftUI

struct TimerRunView: View {
    @Bindable var store: StoreOf<TimerRunFeature>

    var body: some View {
        NavigationView {
            TabView(selection: $store.selectedTab.sending(\.selectedTabChanged)) {
                TimerRunTab(store: store)
                    .tag(0)

                ActionsView(
                    isFirstRunning: store.isFirstRunning,
                    isLastRunning: store.isLastRunning,
                    state: store.state)
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
            .id("horizontal")
            .sheet(item: $store.activityResult.sending(\.activityResultChanged)) { result in
                ActivityResultView(data: result)
            }
        }
        .navigationTitle(store.state == .paused ? LocalizationKey.paused.localizedKey : LocalizationKey.timer.localizedKey)
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            store.send(.onAppear)
        }
    }
}

#Preview {
    TimerRunView(store: ComposableArchitecture.Store(initialState: TimerRunFeature.State()) {
        TimerRunFeature()
            ._printChanges()
    })
}
