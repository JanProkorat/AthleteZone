//
//  TrainingContentScene.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 23.03.2023.
//

import SwiftUI

struct TrainingContentScene: View {
    @EnvironmentObject var router: ViewRouter
    @Environment(\.scenePhase) var scenePhase

    @StateObject var trainingViewModel = TrainingViewModel()
    @StateObject var trainingRunViewModel = TrainingRunViewModel()
    @StateObject var libraryViewModel = TrainingLibraryViewModel()
    @StateObject var settingsViewModel = SettingsViewModel()

    var body: some View {
        GeometryReader { _ in
            VStack {
                switch router.currentTab {
                case .home:
                    TrainingScene()
                        .environmentObject(trainingViewModel)

                case .run:
                    TrainingRunScene()
                        .environmentObject(trainingRunViewModel)

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
            .onChange(of: router.currentTab) { newValue in
                if newValue == .run {
                    if let training = trainingViewModel.selectedTrainingManager.selectedTraining {
                        trainingRunViewModel.initTraining(
                            name: training.name,
                            workouts: Array(training.workouts))
                    }
                }
            }
            .onChange(of: scenePhase) { trainingViewModel.scenePhase = $0 }
        }
    }
}

struct TrainingContentScene_Previews: PreviewProvider {
    static var previews: some View {
        TrainingContentScene()
            .environmentObject(ViewRouter())
    }
}
