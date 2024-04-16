//
//  TrainingContentScene.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 23.03.2023.
//

import ComposableArchitecture
import SwiftUI

struct TrainingContentView: View {
    @Bindable var store: StoreOf<TrainingContentFeature>

    var body: some View {
        TabView(selection: $store.currentTab.sending(\.tabChanged)) {
            VStack {
                if let store = store.scope(state: \.destination?.training, action: \.destination.training) {
                    TrainingView(store: store)
                }
            }
            .tag(Tab.home)

            VStack {
                if let store = store.scope(state: \.destination?.library, action: \.destination.library) {
                    TrainingLibraryView(store: store)
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

struct TrainingContentScene_Previews: PreviewProvider {
    static var previews: some View {
        TrainingContentView(store: ComposableArchitecture.Store(initialState: TrainingContentFeature.State()) {
            TrainingContentFeature()
                ._printChanges()
        })
    }
}
