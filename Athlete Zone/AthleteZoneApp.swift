//
//  Athlete_ZoneApp.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 03.11.2022.
//

import SwiftUI

@main
struct AthleteZoneApp: App {
    @StateObject var router = ViewRouter()
    @StateObject var appStorageManager = AppStorageManager.shared
    @StateObject var launchScreenStateManager = LaunchScreenStateManager()

    var notificationManager = NotificationManager()

    @Environment(\.scenePhase) var scenePhase

    var body: some Scene {
        WindowGroup {
            ZStack {
                switch router.currentSection {
                case .workout:
                    WorkOutContentScene()

                case .training:
//                    TrainingContentScene()
                    Text("")
                }

                if launchScreenStateManager.state != .finished {
                    LaunchScreenView()
                }
            }
            .environmentObject(launchScreenStateManager)
            .environment(\.locale, .init(identifier: "\(appStorageManager.language)"))
            .environment(\.colorScheme, .dark)
            .environmentObject(router)
            .environmentObject(appStorageManager)
            .onAppear {
                if appStorageManager.notificationsEnabled {
                    self.notificationManager.allowNotifications()
                }
            }
        }
    }
}
