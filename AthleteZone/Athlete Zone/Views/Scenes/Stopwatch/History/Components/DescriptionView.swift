//
//  DescriptionView.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 05.12.2023.
//

import SwiftUI

struct DescriptionView: View {
    var property: LocalizedStringKey
    var value: String
    var color: ComponentColor

    var body: some View {
        HStack {
            Text(property)
                .font(.callout)
                .foregroundColor(Color(color.rawValue))
                .scaledToFill()
            Text(":")
                .font(.callout)
                .foregroundColor(Color(color.rawValue))
                .padding(.leading, -7)
            Text(value)
                .font(.callout)
                .foregroundColor(Color(color.rawValue))
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing)
        }
        .padding([.leading, .trailing])
    }
}

#Preview {
    DescriptionView(
        property: LocalizationKey.startDate.localizedKey,
        value: Date().toFormattedString(), color: .braun)
}
