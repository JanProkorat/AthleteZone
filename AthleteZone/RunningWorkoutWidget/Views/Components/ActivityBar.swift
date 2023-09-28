//
//  ActivityBar.swift
//  RunningWorkoutWidgetExtension
//
//  Created by Jan Prokorát on 26.09.2023.
//

import SwiftUI

struct ActivityBar: View {
    var icon: String
    var text: String
    var interval: String
    var color: ComponentColor

    var body: some View {
        HStack {
            HStack {
                Image(systemName: icon)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: 30, maxHeight: 30)
                    .padding(.leading, 10)
                    .padding([.top, .bottom], 2)
                    .foregroundColor(Color(color.rawValue))

                Text(LocalizedStringKey(text))
                    .font(.headline)
                    .bold()
                    .foregroundColor(Color(color.rawValue))
                    .padding(.leading, 5)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Text(interval)
                .font(.headline)
                .bold()
                .foregroundColor(Color(color.rawValue))
                .padding(.trailing)
        }
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .frame(height: 45)
                    .foregroundColor(Color(Background.listItemBackground.rawValue))
            }
        )
        .frame(maxWidth: .infinity)
        .frame(height: 30)
        .padding(.bottom)
    }
}

#Preview {
    ActivityBar(
        icon: "play.circle",
        text: ActivityType.work.rawValue,
        interval: "00:30",
        color: .pink
    )
}
