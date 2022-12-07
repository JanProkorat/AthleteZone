//
//  DescriptionLabel.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 07.11.2022.
//

import SwiftUI

struct DescriptionLabel: View {
    let title: String
    let color: String

    var body: some View {
        Text(title)
            .frame(maxWidth: .infinity, alignment: .center)
            .font(.custom("Lato-Black", size: 20))
            .bold()
            .foregroundColor(Color(color))
            .padding(.trailing)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color(Colors.DarkBlue), lineWidth: 3)
                        .frame(height: 60)
                        .foregroundColor(Color("\(color)_background"))
                    RoundedRectangle(cornerRadius: 20)
                        .frame(height: 60)
                        .foregroundColor(Color("\(color)_background"))
                }
            )
            .frame(minWidth: 0, maxWidth: .infinity)
            .frame(height: 60)
            .padding([.leading, .trailing], 10)
            .padding([.top, .bottom], 3)
    }
}

struct DescriptionLabel_Previews: PreviewProvider {
    static var previews: some View {
        DescriptionLabel(title: "Test", color: "Work")
    }
}
