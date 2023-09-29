//
//  ContentView.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 08.01.2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ContentViewModel()

    @State private var activeTab = 1

    var body: some View {
        ZStack {
            TabView(selection: $activeTab) {
                SectionSetterView()
                    .environmentObject(viewModel)
                    .tag(0)

                Group {
                    if viewModel.currentSection == .workout {
                        WorkoutLibraryView()
                            .environmentObject(viewModel.workoutLibraryViewModel)

                    } else {
                        TrainingLibraryView()
                            .environmentObject(viewModel.trainingLibraryViewModel)
                    }
                }
                .tag(1)

                Group {
                    if viewModel.currentSection == .workout {
                        WorkoutFiltersView()
                            .environmentObject(viewModel.workoutLibraryViewModel)

                    } else {
                        TrainingFiltersView()
                            .environmentObject(viewModel.trainingLibraryViewModel)
                    }
                }
                .tag(2)
            }

            if viewModel.launchScreenState != .finished {
                LaunchScreenView()
                    .environmentObject(viewModel.launchScreenStateManager)
            }
        }
        .environment(\.locale, .init(identifier: "\(viewModel.appStorageManager.language)"))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
