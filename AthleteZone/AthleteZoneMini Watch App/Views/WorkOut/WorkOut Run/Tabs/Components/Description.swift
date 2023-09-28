//
//  Description.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 11.02.2023.
//

import SwiftUI

struct Description: View {
    var title: LocalizedStringKey
    var color: ComponentColor?

    var body: some View {
        Text(title)
            .frame(maxWidth: .infinity, alignment: .center)
            .font(.headline)
            .foregroundColor(color != nil ?
                Color(color!.rawValue) :
                Color.accentColor)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(height: 30)
                        .foregroundColor(Color(Background.listItemBackground.rawValue))
                }
            )
            .frame(minWidth: 0, maxWidth: .infinity)
            .frame(height: 30)
    }
}

struct Description_Previews: PreviewProvider {
    static var previews: some View {
        Description(title: "Test", color: .work)
    }
}
