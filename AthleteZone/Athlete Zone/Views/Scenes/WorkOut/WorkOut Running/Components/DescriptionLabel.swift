//
//  DescriptionLabel.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 07.11.2022.
//

import SwiftUI

struct DescriptionLabel: View {
    let title: LocalizedStringKey
    let color: ComponentColor

    var body: some View {
        Text(title)
            .frame(maxWidth: .infinity, alignment: .center)
            .font(.headline)
            .bold()
            .foregroundColor(Color(color.rawValue))
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color(ComponentColor.darkBlue.rawValue), lineWidth: 3)
                        .frame(height: 60)
                        .foregroundColor(Color(ComponentColor.darkGrey.rawValue))
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

struct DescriptionLabel_Previews: PreviewProvider {
    static var previews: some View {
        DescriptionLabel(title: "Test", color: .lightPink)
    }
}
