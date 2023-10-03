//
//  LibraryView.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 09.02.2023.
//

import SwiftUI

struct WorkoutLibraryView: View {
    @EnvironmentObject var viewModel: WorkOutLibraryViewModel

    var body: some View {
        VStack {
            List(viewModel.getSortedArray(), id: \.id) { workout in
                Button {
                    viewModel.setupRunViewModel(workout)
                } label: {
                    ListItemView(name: workout.name, workOutTime: workout.workoutLength.toFormattedTime())
                }
                .listRowInsets(EdgeInsets(top: 2, leading: 2, bottom: 0, trailing: 2))
            }
            .listStyle(PlainListStyle())
            .environment(\.defaultMinListRowHeight, 40)

            HStack {}
                .frame(height: 2)
                .frame(maxWidth: .infinity)
                .background(Color(ComponentColor.darkBlue.rawValue))
                .padding(.bottom)
        }
        .fullScreenCover(item: $viewModel.selectedWorkOut, content: { _ in
            WorkOutRunView()
                .environmentObject(viewModel.runViewModel)
                .navigationBarHidden(true)

        })
    }
}

#Preview {
    let viewModel = WorkOutLibraryViewModel()
    viewModel.library = [WorkOutDto(
        id: "sadsdsa",
        name: "Test",
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
    return WorkoutLibraryView()
        .environmentObject(viewModel)
}
