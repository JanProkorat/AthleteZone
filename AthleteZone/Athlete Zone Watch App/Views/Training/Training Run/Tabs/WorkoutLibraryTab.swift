//
//  WorkoutLibraryTab.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 24.08.2023.
//

import SwiftUI
//
// struct WorkoutLibraryTab: View {
//    @EnvironmentObject var viewModel: WatchWorkOutRunViewModel
//    var onWorkoutSelect: (() -> Void)?
//
//    var body: some View {
//        BaseView(title: "Workouts") {
//            VStack {
//                List(viewModel.workoutLibrary, id: \.id) { workout in
//                    Button {
//                        viewModel.nextWorkout = workout
//                        viewModel.setState(.finished)
//                        performAction(onWorkoutSelect)
//                    } label: {
//                        ListItemView(name: workout.name, workOutTime: workout.workoutLength.toFormattedTime())
//                    }
//                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
//                }
//                .listStyle(PlainListStyle())
//                .environment(\.defaultMinListRowHeight, 40)
//
//                HStack {}
//                    .frame(height: 10)
//                    .frame(maxWidth: .infinity)
//                    .background(Color(ComponentColor.darkBlue.rawValue))
//                    .padding(.bottom)
//                    .foregroundStyle(.white)
//            }
//        }
//    }
// }
//
// struct WorkoutLibraryTab_Previews: PreviewProvider {
//    static var previews: some View {
//        WorkoutLibraryTab()
//            .environmentObject(
//                WatchWorkOutRunViewModel()
//            )
//    }
// }
//
// extension WorkoutLibraryTab {
//    func onWorkoutSelect(_ handler: @escaping () -> Void) -> WorkoutLibraryTab {
//        var new = self
//        new.onWorkoutSelect = handler
//        return new
//    }
// }
//
// #Preview {
//    let viewModel = WatchWorkOutRunViewModel()
//    viewModel.workoutLibrary = [WorkoutDto(
//        id: "sadsdsa",
//        name: "Test",
//        work: 30,
//        rest: 15,
//        series: 2,
//        rounds: 4,
//        reset: 60,
//        createdDate: Date(),
//        workoutLength: 40
//    ),
//    WorkoutDto(
//        id: "1",
//        name: "Prvni",
//        work: 2,
//        rest: 2,
//        series: 2,
//        rounds: 2,
//        reset: 30,
//        createdDate: Date(),
//        workoutLength: 50
//    ),
//    WorkoutDto(
//        id: "2",
//        name: "Druhy",
//        work: 3,
//        rest: 3,
//        series: 3,
//        rounds: 3,
//        reset: 30,
//        createdDate: Date(),
//        workoutLength: 50
//    ),
//    WorkoutDto(
//        id: "3",
//        name: "Treti",
//        work: 2,
//        rest: 2,
//        series: 2,
//        rounds: 2,
//        reset: 30,
//        createdDate: Date(),
//        workoutLength: 50
//    ),
//    WorkoutDto(
//        id: "4",
//        name: "Ctvrty",
//        work: 3,
//        rest: 3,
//        series: 3,
//        rounds: 3,
//        reset: 30,
//        createdDate: Date(),
//        workoutLength: 50
//    )]
//    return WorkoutLibraryTab()
//        .environmentObject(viewModel)
// }
