//
//  TimeTrackingContentView.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 04.03.2024.
//

import ComposableArchitecture
import SwiftUI

struct TimeTrackingContentView: View {
    @Bindable var store: StoreOf<TimeTrackingContentFeature>

    var body: some View {
        TabView(selection: $store.currentTab.sending(\.tabChanged)) {
            VStack {
                if let store = store.scope(state: \.destination?.timeTracting, action: \.destination.timeTracting) {
                    TimeTrackingView(store: store)
                }
            }
            .tag(Tab.home)

            VStack {
                if let store = store.scope(state: \.destination?.library, action: \.destination.library) {
                    HistoryView(store: store)
                }
            }
            .tag(Tab.library)

            VStack {
                if let store = store.scope(state: \.destination?.settings, action: \.destination.settings) {
                    SettingsView(store: store)
                }
            }
            .tag(Tab.settings)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
    }
}

#Preview {
    TimeTrackingContentView(store: ComposableArchitecture.Store(initialState: TimeTrackingContentFeature.State(), reducer: {
        TimeTrackingContentFeature()
            ._printChanges()
    }))
}
