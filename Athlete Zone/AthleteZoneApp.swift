//
//  Athlete_ZoneApp.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 03.11.2022.
//

import SwiftUI

@main
struct AthleteZoneApp: App {
    @StateObject var launchScreenStateManager = LaunchScreenStateManager()

    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView()

                if launchScreenStateManager.state != .finished {
                    LaunchScreenView()
                }
            }
            .environmentObject(launchScreenStateManager)
        }
    }
}
