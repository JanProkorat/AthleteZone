//
//  TrainingLibraryView.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 23.08.2023.
//

import SwiftUI

struct TrainingLibraryView: View {
    @EnvironmentObject var viewModel: TrainingLibraryViewModel

    var body: some View {
        BaseView(title: "Trainings") {
            VStack {
                List(viewModel.getSortedArray(), id: \.id) { training in
                    Button {
                        viewModel.setSelectedTraining(training)
                    } label: {
                        ListItemView(name: training.name, workOutTime: training.trainingLength.toFormattedTime())
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
        .fullScreenCover(item: $viewModel.selectedTraining, content: { _ in
            TrainingRunView()
                .onQuitTab { viewModel.selectedTraining = nil }
//                .environmentObject(
//                    TrainingRunViewModel(
//                        trainingName: training.name,
//                        workouts: Array(training.workouts)
//                    )
//                )
                .navigationBarHidden(true)
        })
    }
}

struct TrainingLibraryView_Previews: PreviewProvider {
    static var previews: some View {
        TrainingLibraryView()
            .environmentObject(TrainingLibraryViewModel())
    }
}
