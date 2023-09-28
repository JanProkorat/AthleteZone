//
//  TrainingContentScene.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 23.03.2023.
//

import SwiftUI

struct TrainingContentScene: View {
    @Environment(\.scenePhase) var scenePhase

    @StateObject var viewModel = TrainingContentViewModel()

    @StateObject var trainingViewModel = TrainingViewModel()
    @StateObject var libraryViewModel = TrainingLibraryViewModel()
    @StateObject var settingsViewModel = SettingsViewModel()

    var body: some View {
        GeometryReader { _ in
            VStack {
                switch viewModel.currentTab {
                case .home:
                    TrainingScene(isRunViewVisible: $trainingViewModel.isRunViewVisible)
                        .environmentObject(trainingViewModel)

                case .library:
                    TrainingLibraryScene()
                        .environmentObject(libraryViewModel)

                case .setting:
                    SettingsScene()
                        .environmentObject(settingsViewModel)

                default:
                    Text("Scene for this route not implemented")
                }
            }
            .animation(.easeInOut, value: viewModel.currentTab)
            .onChange(of: scenePhase) { trainingViewModel.scenePhase = $0 }
        }
    }
}

struct TrainingContentScene_Previews: PreviewProvider {
    static var previews: some View {
        TrainingContentScene()
    }
}
