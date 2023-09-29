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
        BaseView(title: "Workouts") {
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
                .environment(\.defaultMinListRowHeight, 50)

                HStack {}
                    .frame(height: 10)
                    .frame(maxWidth: .infinity)
                    .background(Color(ComponentColor.darkBlue.rawValue))
                    .padding(.bottom)
            }
        }
        .fullScreenCover(item: $viewModel.selectedWorkOut, content: { _ in
            WorkOutRunView()
                .environmentObject(viewModel.runViewModel)
                .navigationBarHidden(true)

        })
    }
}

struct WorkoutLibraryView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutLibraryView()
            .environmentObject(WorkOutLibraryViewModel())
    }
}
