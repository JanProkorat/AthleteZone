//
//  AthleteZoneMiniApp.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 08.01.2023.
//

import ComposableArchitecture
import SwiftUI

@main
struct AthleteZoneMiniWatchAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(store: ComposableArchitecture.Store(initialState: ContentFeature.State()) {
                ContentFeature()
                    ._printChanges()
            })
        }
    }
}
