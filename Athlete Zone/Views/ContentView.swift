//
//  ContentView.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 14.07.2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject var router = ViewRouter()
    @StateObject var appStorageManager = AppStorageManager.shared
    @EnvironmentObject var launchScreenStateManager: LaunchScreenStateManager

    var notificationManager = NotificationManager()
    @Environment(\.scenePhase) var scenePhase

    var body: some View {
        ZStack(content: {
            switch router.currentSection {
            case .workout:
                WorkOutContentScene()

            case .training:
                TrainingContentScene()
            }
        })
        .environment(\.locale, .init(identifier: "\(appStorageManager.language)"))
        .environment(\.colorScheme, .dark)
        .environmentObject(router)
        .environmentObject(appStorageManager)
        .onAppear {
            self.router.currentSection = self.appStorageManager.selectedSection
            if appStorageManager.notificationsEnabled {
                self.notificationManager.allowNotifications()
            }
            self.launchScreenStateManager.dismiss()
        }
        .onChange(of: router.currentSection) { newValue in
            self.appStorageManager.selectedSection = newValue
        }
//        .animation(.default)
//        .transition(.slide)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(LaunchScreenStateManager())
    }
}
