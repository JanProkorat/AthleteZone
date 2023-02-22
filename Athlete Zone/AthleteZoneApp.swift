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
    @StateObject var workOutViewModel = WorkOutViewModel()
    @StateObject var appStorageManager = AppStorageManager.shared

    @Environment(\.scenePhase) var scenePhase

    var body: some Scene {
        WindowGroup {
            ContentScene()
                .environment(\.locale, .init(identifier: "\(appStorageManager.language)"))
                .environment(\.colorScheme, .dark)
                .environmentObject(router)
                .environmentObject(workOutViewModel)
        }
    }
}
