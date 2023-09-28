//
//  DefaultView.swift
//  RunningWorkoutWidgetExtension
//
//  Created by Jan Prokorát on 26.09.2023.
//

import SwiftUI

struct DefaultMediumView: View {
    var body: some View {
        HStack {
            HStack {
                VStack {
                    HeaderText(text: "Athlete Zone")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading)

                    DescriptionBar(text: "Work: __:__", color: .pink)
                    DescriptionBar(text: "Rest: __:__", color: .yellow)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            HStack {
                VStack {
                    HeaderText(text: "__:__")
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.trailing)

                    DescriptionBar(text: "Series: _", color: .lightBlue)
                    DescriptionBar(text: "Rounds: _", color: .lightGreen)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    DefaultMediumView()
}
