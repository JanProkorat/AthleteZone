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
                .padding(.leading, 15)
                .font(.title3)
                .lineLimit(1)
            Text(workOutTime)
                .padding(.trailing, 15)
                .font(.title3)
        }
        .frame(width: .infinity, height: 50)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .frame(maxHeight: 50)
                    .foregroundColor(Color(Background.listItemBackground.rawValue))
            }
        )
    }
}

struct ListItemView_Previews: PreviewProvider {
    static var previews: some View {
        ListItemView(name: "title", workOutTime: "10:00")
    }
}
