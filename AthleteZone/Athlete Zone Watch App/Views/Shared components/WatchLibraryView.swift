//
//  WatchLibraryView.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 02.10.2023.
//

import SwiftUI

struct WatchLibraryView: View {
    @EnvironmentObject var viewModel: ContentViewModel

    var body: some View {
        BaseView(title: "Library") {
//            VStack {
//                HStack {
//                    SectionButton(title: "Workouts", section: viewModel.currentSection, expectedSection: .workout)
//                        .onTab { viewModel.settingsManager.currentSection = .workout }
//
//                    SectionButton(title: "Trainings", section: viewModel.currentSection, expectedSection: .training)
//                        .onTab { viewModel.settingsManager.currentSection = .training }
//                }
//                .padding([.top, .bottom])
//
//                switch viewModel.currentSection {
            ////                case .workout:
            ////                    WorkoutLibraryView()
            ////                        .environmentObject(viewModel.workoutLibraryViewModel)
            ////
            ////                case .training:
            ////                    TrainingLibraryView()
            ////                        .environmentObject(viewModel.trainingLibraryViewModel)
//
//                default:
            Text("")
//                }
//            }
//            .animation(.default, value: viewModel.currentSection)
        }
    }
}

#Preview {
//    let viewModel = ContentViewModel()
//    viewModel.workoutLibraryViewModel.setLibrary([WorkoutDto(
//            id: "sadsdsa",
//            name: "Test",
//            work: 30,
//            rest: 15,
//            series: 2,
//            rounds: 4,
//            reset: 60,
//            createdDate: Date(),
//            workoutLength: 40
//        ),
//        WorkoutDto(
//            id: "1",
//            name: "Prvni",
//            work: 2,
//            rest: 2,
//            series: 2,
//            rounds: 2,
//            reset: 30,
//            createdDate: Date(),
//            workoutLength: 50
//        ),
//        WorkoutDto(
//            id: "2",
//            name: "Druhy",
//            work: 3,
//            rest: 3,
//            series: 3,
//            rounds: 3,
//            reset: 30,
//            createdDate: Date(),
//            workoutLength: 50
//        ),
//        WorkoutDto(
//            id: "3",
//            name: "Treti",
//            work: 2,
//            rest: 2,
//            series: 2,
//            rounds: 2,
//            reset: 30,
//            createdDate: Date(),
//            workoutLength: 50
//        ),
//        WorkoutDto(
//            id: "4",
//            name: "Ctvrty",
//            work: 3,
//            rest: 3,
//            series: 3,
//            rounds: 3,
//            reset: 30,
//            createdDate: Date(),
//            workoutLength: 50
//        )])
    WatchLibraryView()
//        .environmentObject(viewModel)
}
