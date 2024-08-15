//
//  TrainingDetailView.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 12.12.2023.
//

import SwiftUI

struct TrainingDetailView: View {
    @Binding var training: TrainingDto?

    var body: some View {
        DetailBaseView(title: training?.name ?? "") {
            if let train = training {
                VStack {
                    if !train.trainingDescription.isEmpty {
                        Text(train.trainingDescription)
                            .font(.subheadline)
                            .padding()
                    }

                    Divider()
                        .overlay(.white)

                    List(train.workouts, id: \.id) { workout in
                        WorkOutListView(workOut: workout, buttonsEnabled: false)
                            .padding(.bottom, 120)
                            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                            .background(Color(ComponentColor.darkBlue.rawValue))
                    }
                    .listStyle(.plain)
                    .overlay(alignment: .top) {
                        if train.workouts.isEmpty {
                            Text(LocalizationKey.noWorkoutsToDisplay.localizedKey)
                                .font(.headline)
                                .bold()
                                .padding(.top, 25)
                        }
                    }
                    .padding(.top, 5)
                }
            }
        }
        .onCloseTab { training = nil }
    }
}

#Preview {
    TrainingDetailView(
        training: Binding.constant(TrainingDto(
            id: "1",
            name: "asda",
            trainingDescription: "adasd asda asdas",
            workoutsCount: 2,
            trainingLength: 120,
            createdDate: Date(),
            workouts: []
        ))
    )
}
