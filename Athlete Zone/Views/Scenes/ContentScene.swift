//
//  ContentView.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 06.11.2022.
//

import SwiftUI

struct ContentScene: View {
    @EnvironmentObject var router: ViewRouter
    @EnvironmentObject var appStorageManager: AppStorageManager

    @StateObject var workOutViewModel = WorkOutViewModel()
    @StateObject var workFlowViewModel = WorkFlowViewModel()
    @StateObject var launchScreenState = LaunchScreenStateManager()
    @StateObject var libraryViewModel = LibraryViewModel()
    @StateObject var settingsViewModel = SettingsViewModel()

    @Environment(\.scenePhase) var scenePhase

    var body: some View {
        GeometryReader { _ in
            ZStack {
                content

                if launchScreenState.state != .finished {
                    LaunchScreenView()
                }
            }
            .environmentObject(launchScreenState)
            .onAppear {
                if !self.appStorageManager.selectedItemId.isEmpty {
                    self.workOutViewModel.loadWorkoutById(self.appStorageManager.selectedItemId)
                }
                self.launchScreenState.dismiss()
            }
            .onChange(of: router.currentTab, perform: { newValue in
                if newValue == .workoutRun {
                    workFlowViewModel.createWorkFlow(
                        workOutViewModel.name,
                        workOutViewModel.work,
                        workOutViewModel.rest,
                        workOutViewModel.series,
                        workOutViewModel.rounds,
                        workOutViewModel.reset)
                }
            })
            .onChange(of: scenePhase) { newPhase in
                if (newPhase == .inactive || newPhase == .background) && workOutViewModel._id != nil {
                    appStorageManager.selectedItemId = workOutViewModel._id!
                }
            }
        }
    }

    @ViewBuilder
    private var content: some View {
        VStack {
            switch router.currentTab {
            case .home:
                WorkOutScene()
                    .environmentObject(workOutViewModel)

            case .library:
                LibraryScene()
                    .environmentObject(libraryViewModel)

            case .profile:
                ProfileScene()

            case .setting:
                SettingsScene()
                    .environmentObject(settingsViewModel)

            case .workoutRun:
                WorkOutRunScene()
                    .environmentObject(workFlowViewModel)
            }
        }
        .environmentObject(router)
        .background(Color(Background.background.rawValue))
        .animation(.easeInOut, value: router.currentTab)
    }
}

struct ContentScene_Previews: PreviewProvider {
    static var previews: some View {
        ContentScene()
            .environmentObject(ViewRouter())
            .environmentObject(AppStorageManager())
    }
}
