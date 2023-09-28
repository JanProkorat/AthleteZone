//
//  WidgetTrainingMediumView.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 26.09.2023.
//

import SwiftUI

struct WidgetTrainingMediumView: View {
    var training: WidgetTraining

    var body: some View {
        HStack {
            VStack {
                HStack {
                    HeaderText(text: training.name)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading)

                    HeaderText(text: training.trainingLength.toFormattedTime())
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.trailing)
                }

                Spacer()

                HStack {
                    Text(training.trainingDescription)
                        .foregroundColor(Color(ComponentColor.lightBlue.rawValue))
                        .font(.headline)
                        .padding([.leading, .trailing])
                }
                .padding(.top)
                .frame(maxWidth: .infinity)
                .background(
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(height: 75)
                            .padding(.top)
                            .foregroundColor(Color(Background.listItemBackground.rawValue))
                    }
                )

                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    WidgetTrainingMediumView(
        training: WidgetTraining(
            id: "sdas",
            name: "Test",
            trainingDescription: "description",
            workoutsCount: 3,
            trainingLength: 145
        )
    )
}
