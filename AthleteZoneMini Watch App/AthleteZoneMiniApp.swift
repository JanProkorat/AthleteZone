//
//  AthleteZoneMiniApp.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 08.01.2023.
//

import SwiftUI

@main
struct AthleteZoneMiniWatchAppApp: App {
    @StateObject var viewModel = ViewModel()
    @StateObject var appStorageManager = AppStorageManager.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
                .environment(\.colorScheme, .dark)
                .environment(\.locale, .init(identifier: "\(appStorageManager.language)"))
        }
    }
}
