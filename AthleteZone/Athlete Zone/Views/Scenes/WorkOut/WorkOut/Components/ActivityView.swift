//
//  ActivityView.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 04.11.2022.
//

import SwiftUI

struct ActivityView: View {
    let image: String
    let color: ComponentColor
    let activity: LocalizedStringKey
    let interval: Int
    let type: LabelType

    var body: some View {
        HStack {
            HStack {
                IconButton(id: "\(activity)Icon", image: image, color: color, width: 50, height: 45)
                    .padding(.leading, 10)
                Text(activity)
                    .font(.headline)
                    .bold()
                    .foregroundColor(Color(color.rawValue))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Text(interval.toFormattedValue(type: type))
                .font(.headline)
                .bold()
                .foregroundColor(Color(color.rawValue))
                .padding(.trailing)
        }
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .frame(height: 60)
                    .foregroundColor(Color(ComponentColor.darkGrey.rawValue))
            }
        )
        .frame(minWidth: 0, maxWidth: .infinity)
        .frame(height: 60)
        .padding([.top, .bottom], 3)
    }
}

struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityView(image: Icon.play.rawValue, color: ComponentColor.lightPink,
                     activity: "Work", interval: 40, type: .time)
    }
}
