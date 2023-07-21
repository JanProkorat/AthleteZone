//
//  ContentView.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 06.11.2022.
//

import SwiftUI

struct WorkOutContentScene: View {
    @Environment(\.scenePhase) var scenePhase

    @StateObject var viewModel = WorkOutContentViewModel()

    @StateObject var workOutViewModel = WorkOutViewModel()
    @StateObject var libraryViewModel = LibraryViewModel()
    @StateObject var settingsViewModel = SettingsViewModel()

    var body: some View {
        GeometryReader { _ in
            VStack {
                switch viewModel.currentTab {
                case .home:
                    WorkOutScene()
                        .environmentObject(workOutViewModel)

                case .library:
                    LibraryScene()
                        .environmentObject(libraryViewModel)

                case .setting:
                    SettingsScene()
                        .environmentObject(settingsViewModel)

                default:
                    Text("Scene for this route not implemented")
                }
            }
            .animation(.easeInOut, value: viewModel.currentTab)
            .onChange(of: scenePhase) { workOutViewModel.scenePhase = $0 }
        }
    }
}

struct ContentScene_Previews: PreviewProvider {
    static var previews: some View {
        WorkOutContentScene()
    }
}
