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
        NavigationBaseView(currentTab: viewModel.currentTab) {
            TrainingScene(isRunViewVisible: $trainingViewModel.isRunViewVisible)
                .environmentObject(trainingViewModel)
        } library: {
            TrainingLibraryScene()
                .environmentObject(libraryViewModel)
        }
        .onChange(of: scenePhase) { _, newValue in
            trainingViewModel.scenePhase = newValue
        }
    }
}

struct TrainingContentScene_Previews: PreviewProvider {
    static var previews: some View {
        TrainingContentScene()
    }
}
