//
//  TrainingLibraryView.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 23.08.2023.
//

import SwiftUI
//
// struct TrainingLibraryView: View {
//    @EnvironmentObject var viewModel: TrainingLibraryViewModel
//
//    var body: some View {
//        VStack {
//            List(viewModel.getSortedArray(), id: \.id) { training in
//                Button {
//                    viewModel.setupViewModel(training)
//                } label: {
//                    ListItemView(name: training.name, workOutTime: training.trainingLength.toFormattedTime())
//                }
//                .listRowInsets(EdgeInsets(top: 2, leading: 2, bottom: 0, trailing: 2))
//            }
//            .listStyle(PlainListStyle())
//            .environment(\.defaultMinListRowHeight, 40)
//            .overlay(alignment: .top) {
//                if viewModel.library.isEmpty {
//                    Text("No trainings to display. Define trainings in iOS app or swipe left to start quick workout")
//                        .font(.footnote)
//                        .padding([.top, .leading, .trailing])
//                }
//            }
//            HStack {}
//                .frame(height: 2)
//                .frame(maxWidth: .infinity)
//                .background(Color(ComponentColor.darkBlue.rawValue))
//                .padding(.bottom)
//        }
//    }
// }
//
// #Preview {
//    let viewModel = TrainingLibraryViewModel()
//    viewModel.setLibrary([
//        TrainingDto(
//            id: "1",
//            name: "test",
//            trainingDescription: "asdojlas aklsdj lkasd",
//            workoutsCount: 3,
//            trainingLength: 587,
//            createdDate: Date(),
//            workouts: [
//                WorkoutDto(
//                    id: "1",
//                    name: "Prvni",
//                    work: 2,
//                    rest: 2,
//                    series: 2,
//                    rounds: 2,
//                    reset: 30,
//                    createdDate: Date(),
//                    workoutLength: 50
//                ),
//                WorkoutDto(
//                    id: "2",
//                    name: "Druhy",
//                    work: 3,
//                    rest: 3,
//                    series: 3,
//                    rounds: 3,
//                    reset: 30,
//                    createdDate: Date(),
//                    workoutLength: 50
//                ),
//                WorkoutDto(
//                    id: "sadsdsa",
//                    name: "Test",
//                    work: 30,
//                    rest: 15,
//                    series: 2,
//                    rounds: 4,
//                    reset: 60,
//                    createdDate: Date(),
//                    workoutLength: 40
//                )
//            ]
//        )
//    ])
//    return TrainingLibraryView()
//        .environmentObject(viewModel)
// }
