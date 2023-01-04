//
//  ContentView.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 06.11.2022.
//

import SwiftUI

struct ContentScene: View {
    @StateObject var router: ViewRouter
    @StateObject var workOutViewModel = WorkOutViewModel()

    var body: some View {
        GeometryReader { _ in
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
            .animation(.easeInOut, value: router.currentTab)
            .background(Color(Background.background.rawValue))
        }
    }
}

struct ContentScene_Previews: PreviewProvider {
    static var previews: some View {
        ContentScene(router: ViewRouter())
            .environmentObject(WorkOutViewModel())
            .environmentObject(ViewRouter())
    }
}
