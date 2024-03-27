//
//  Athlete_ZoneApp.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 03.11.2022.
//

import ComposableArchitecture
import SwiftUI

@main
struct AthleteZoneApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView(store: ComposableArchitecture.Store(initialState: ContentFeature.State()) {
                ContentFeature()
                    ._printChanges()
            })
        }
    }
}
