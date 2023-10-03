//
//  ContentView.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 08.01.2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ContentViewModel()

    var body: some View {
        ZStack {
            TabView {
                WatchLibraryView()
                    .environmentObject(viewModel)

                Group {
                    if viewModel.currentSection == .workout {
                        WorkoutFiltersView()
                            .environmentObject(viewModel.workoutLibraryViewModel)

                    } else {
                        TrainingFiltersView()
                            .environmentObject(viewModel.trainingLibraryViewModel)
                    }
                }
            }

//            if viewModel.launchScreenState != .finished {
//                LaunchScreenView()
//                    .environmentObject(viewModel.launchScreenStateManager)
//            }
        }
        .environment(\.locale, .init(identifier: "\(viewModel.appStorageManager.language)"))
    }
}

#Preview {
    let viewModel = ContentViewModel()
    viewModel.workoutLibraryViewModel.library = [WorkOutDto(
        id: "sadsdsa",
        name: "Hodne dlouhy nazev",
        work: 30,
        rest: 15,
        series: 2,
        rounds: 4,
        reset: 60,
        createdDate: Date(),
        workoutLength: 40
    ),
    WorkOutDto(
        id: "1",
        name: "Prvni",
        work: 2,
        rest: 2,
        series: 2,
        rounds: 2,
        reset: 30,
        createdDate: Date(),
        workoutLength: 50
    ),
    WorkOutDto(
        id: "2",
        name: "Druhy",
        work: 3,
        rest: 3,
        series: 3,
        rounds: 3,
        reset: 30,
        createdDate: Date(),
        workoutLength: 50
    ),
    WorkOutDto(
        id: "3",
        name: "Treti",
        work: 2,
        rest: 2,
        series: 2,
        rounds: 2,
        reset: 30,
        createdDate: Date(),
        workoutLength: 50
    ),
    WorkOutDto(
        id: "4",
        name: "Ctvrty",
        work: 3,
        rest: 3,
        series: 3,
        rounds: 3,
        reset: 30,
        createdDate: Date(),
        workoutLength: 50
    )]
    return ContentView(viewModel: viewModel)
}
