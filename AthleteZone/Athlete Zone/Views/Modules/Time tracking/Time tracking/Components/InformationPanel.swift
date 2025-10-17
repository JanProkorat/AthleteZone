//
//  InformationPanel.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 27.01.2025.
//

import SwiftUI

struct InformationPanel: View {
    var image: String
    var size: CGFloat
    var color: ComponentColor
    var label: LocalizationKey
    var text: String

    var body: some View {
        HStack {
            HStack {
                Image(systemName: image)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: size * 0.7, maxHeight: size * 0.7)
                    .padding(.leading, 10)
                    .padding([.top, .bottom], 2)
                    .foregroundColor(Color(color.rawValue))

                Text(label.localizedKey)
                    .font(.title3)
                    .foregroundColor(Color(color.rawValue))
                    .padding(.leading, 5)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Text(LocalizedStringKey(text))
                .font(.headline)
                .bold()
                .foregroundColor(Color(color.rawValue))
                .padding(.trailing)
        }
        .roundedBackground(cornerRadius: 20, color: .darkGrey, height: size)
        .frame(maxWidth: .infinity)
        .frame(height: size)
        .padding(.bottom, 3)
    }
}

#Preview {
    InformationPanel(
        image: "clock.badge.questionmark",
        size: 50,
        color: .lightPink,
        label: LocalizationKey.lastActivity,
        text: TimerType.stopWatch.rawValue
    )
}
