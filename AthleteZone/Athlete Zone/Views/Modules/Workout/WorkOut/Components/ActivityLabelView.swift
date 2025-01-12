//
//  ActivityLabelView.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 24.02.2024.
//

import SwiftUI

struct ActivityLabelView: View {
    var image: String
    var size: CGFloat
    var color: ComponentColor
    var type: ActivityType
    var labelType: LabelType
    var interval: Int

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

                Text(LocalizedStringKey(type.rawValue))
                    .font(.title3)
                    .foregroundColor(Color(color.rawValue))
                    .padding(.leading, 5)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            HStack {
                if interval == 0 {
                    Image(systemName: "exclamationmark.circle")
                        .foregroundColor(.red)
                        .padding(.trailing)
                }

                Text(interval.toFormattedValue(type: labelType))
                    .font(.headline)
                    .bold()
                    .foregroundColor(interval == 0 ? .red : Color(color.rawValue))
                    .padding(.trailing)
            }
            .animation(.default, value: interval)
        }
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .frame(height: size)
                    .foregroundColor(Color(ComponentColor.darkGrey.rawValue))
            }
        )
        .frame(maxWidth: .infinity)
        .frame(height: size)
        .padding(.bottom, 3)
    }
}

#Preview {
    ActivityLabelView(
        image: "play.circle",
        size: 40,
        color: .lightPink,
        type: .work,
        labelType: .time,
        interval: 30
    )
}
