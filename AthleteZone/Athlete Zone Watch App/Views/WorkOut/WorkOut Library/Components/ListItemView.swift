//
//  ListItemView.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 09.02.2023.
//

import SwiftUI

struct ListItemView: View {
    var name: String
    var workOutTime: String

    var body: some View {
        HStack {
            Text(name)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 10)
                .font(.footnote)
                .lineLimit(2)
                .foregroundStyle(.white)

            Text(workOutTime)
                .padding(.trailing, 10)
                .font(.caption)
                .foregroundStyle(.white)
        }
        .frame(width: .infinity, height: 40)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .frame(maxHeight: 40)
                    .foregroundColor(Color(ComponentColor.darkGrey.rawValue))
            }
        )
    }
}

struct ListItemView_Previews: PreviewProvider {
    static var previews: some View {
        ListItemView(name: "title", workOutTime: "10:00")
    }
}
