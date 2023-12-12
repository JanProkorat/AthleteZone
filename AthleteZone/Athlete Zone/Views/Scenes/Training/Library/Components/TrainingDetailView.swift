//
//  TrainingDetailView.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 12.12.2023.
//

import SwiftUI

struct TrainingDetailView: View {
    var training: Training

    var body: some View {
        GeometryReader(content: { geometry in
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color(ComponentColor.darkGrey.rawValue), lineWidth: 3)
                        .foregroundColor(Color(ComponentColor.darkGrey.rawValue))
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(Color(ComponentColor.darkBlue.rawValue))
                    Text(training.name)
                        .font(.title)
                        .foregroundColor(Color(ComponentColor.mainText.rawValue))
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding(.top, 20)
                .padding([.leading, .trailing], 10)
                .frame(maxHeight: 80)

                if !training.trainingDescription.isEmpty {
                    VStack {
                        Text(training.trainingDescription)
                    }
                    .frame(maxHeight: geometry.size.height * 0.17, alignment: .top)
                    .padding()
                }

                Text(LocalizationKey.workouts.localizedKey)
                    .font(.title3)
                    .padding(.top, 4)
                Divider()
                    .overlay(Color.white)
                    .padding([.leading, .trailing])

                List(training.workouts, id: \._id) { workout in
                    WorkOutListView(workOut: workout, buttonsEnabled: false)
                        .padding([.leading, .trailing], 2)
                        .padding(.bottom, 120)
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        .background(Color(ComponentColor.darkBlue.rawValue))
                }
                .listStyle(.plain)
                .overlay(alignment: .top) {
                    if training.workouts.isEmpty {
                        Text(LocalizationKey.noWorkoutsToDisplay.localizedKey)
                            .font(.headline)
                            .bold()
                            .padding(.top, 100)
                    }
                }
                .padding([.leading, .trailing])
            }
            .background(Color(ComponentColor.darkBlue.rawValue))
            .environment(\.colorScheme, .dark)
        })
    }
}

#Preview {
    TrainingDetailView(training: Training())
}
