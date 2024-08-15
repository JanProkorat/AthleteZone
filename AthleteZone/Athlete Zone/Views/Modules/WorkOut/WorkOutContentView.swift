//
//  ContentView.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 06.11.2022.
//

import ComposableArchitecture
import SwiftUI

struct WorkOutContentView: View {
    @Bindable var store: StoreOf<WorkoutContentFeature>

    var body: some View {
        TabView(selection: $store.currentTab.sending(\.tabChanged)) {
            VStack {
                if let store = store.scope(state: \.destination?.workout, action: \.destination.workout) {
                    WorkoutView(store: store)
                }
            }
            .tag(Tab.home)

            VStack {
                if let store = store.scope(state: \.destination?.library, action: \.destination.library) {
                    WorkoutLibraryView(store: store)
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

struct ContentScene_Previews: PreviewProvider {
    static var previews: some View {
        WorkOutContentView(store: ComposableArchitecture.Store(initialState: WorkoutContentFeature.State()) {
            WorkoutContentFeature()
                ._printChanges()
        })
    }
}
