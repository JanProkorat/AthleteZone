//
//  ContentView.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 06.11.2022.
//

import SwiftUI

struct WorkOutContentScene: View {
    @EnvironmentObject var router: ViewRouter
    @EnvironmentObject var appStorageManager: AppStorageManager

    @StateObject var workOutViewModel = WorkOutViewModel()
    @StateObject var workFlowViewModel = WorkFlowViewModel()
    @StateObject var libraryViewModel = LibraryViewModel()
    @StateObject var settingsViewModel = SettingsViewModel()

    @Environment(\.scenePhase) var scenePhase

    var body: some View {
        GeometryReader { _ in
            VStack {
                switch router.currentTab {
                case .home:
                    WorkOutScene()
                        .environmentObject(workOutViewModel)

                case .library:
                    LibraryScene()
                        .environmentObject(libraryViewModel)

                case .setting:
                    SettingsScene()
                        .environmentObject(settingsViewModel)

                case .run:
                    WorkOutRunScene()
                        .environmentObject(workFlowViewModel)

                default:
                    Text("Scene for this route not implemented")
                }
            }
            .onAppear {
                if !self.appStorageManager.selectedWorkoutId.isEmpty {
                    self.workOutViewModel.loadWorkoutById(self.appStorageManager.selectedWorkoutId)
                }
            }
            .onChange(of: router.currentTab, perform: { newValue in
                if newValue == .run {
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
                    appStorageManager.selectedWorkoutId = workOutViewModel._id!
                }
            }
            .environmentObject(router)
            .background(Color(Background.background.rawValue))
            .animation(.easeInOut, value: router.currentTab)
        }
    }
}

struct ContentScene_Previews: PreviewProvider {
    static var previews: some View {
        WorkOutContentScene()
            .environmentObject(ViewRouter())
            .environmentObject(AppStorageManager())
    }
}
