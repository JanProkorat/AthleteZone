//
//  AthleteZoneMiniApp.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 08.01.2023.
//

import SwiftUI

@main
struct AthleteZoneMiniWatchAppApp: App {
    @StateObject var appStorageManager = AppStorageManager.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.colorScheme, .dark)
                .environment(\.locale, .init(identifier: "\(appStorageManager.language)"))
        }
    }
}
