//
//  ContentView.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 06.11.2022.
//

import SwiftUI

struct ContentScene: View {
    @EnvironmentObject var router: ViewRouter
    @EnvironmentObject var workOutViewModel: WorkOutViewModel
    @StateObject var launchScreenState = LaunchScreenStateManager()

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
                self.launchScreenState.dismiss()
            }
        }
    }

    @ViewBuilder
    private var content: some View {
        VStack {
            switch router.currentTab {
            case .home:
                WorkOutScene()

            case .library:
                LibraryScene()

            case .profile:
                ProfileScene()

            case .setting:
                SettingsScene()

            case .workoutRun:
                WorkOutRunScene()
            }
        }
        .environmentObject(router)
        .environmentObject(workOutViewModel)
        .background(Color(Background.background.rawValue))
        .animation(.easeInOut, value: router.currentTab)
    }
}

struct ContentScene_Previews: PreviewProvider {
    static var previews: some View {
        ContentScene()
            .environmentObject(WorkOutViewModel())
            .environmentObject(ViewRouter())
    }
}
