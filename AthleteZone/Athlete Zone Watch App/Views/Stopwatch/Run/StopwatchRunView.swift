//
//  StopwatchRunView.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 06.06.2024.
//

import ComposableArchitecture
import SwiftUI

struct StopwatchRunView: View {
    @Bindable var store: StoreOf<StopwatchRunFeature>

    var body: some View {
        NavigationView {
            TabView(selection: $store.selectedTab.sending(\.selectedTabChanged)) {
                SplitTimesTab(times: store.splitTimes)
                    .tag(0)

                StopwatchRunTab(store: store)
                    .tag(1)

                StopwatchActionsTab(store: store)
                    .tag(2)
            }
            .padding([.leading, .trailing], 5)
            .id("horizontal")
            .sheet(item: $store.activityResult.sending(\.activityResultChanged)) { result in
                ActivityResultView(data: result)
            }
        }
        .navigationTitle(store.state == .paused ? LocalizationKey.paused.localizedKey : LocalizationKey.stopWatch.localizedKey)
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            store.send(.onAppear)
        }
    }
}

#Preview {
    StopwatchRunView(store: ComposableArchitecture.Store(initialState: StopwatchRunFeature.State()) {
        StopwatchRunFeature()
            ._printChanges()
    })
}
