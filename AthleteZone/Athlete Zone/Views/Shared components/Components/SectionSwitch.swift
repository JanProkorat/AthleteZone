//
//  SectionSwitch.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 23.03.2023.
//

import SwiftUI

struct SectionSwitch: View {
    @StateObject var router = ViewRouter.shared

    var body: some View {
        Menu {
            ForEach(Section.allCases.sorted(by: { $0.rawValue > $1.rawValue }), id: \.self) { section in
                Button(action: {
                    router.currentSection = section
                }, label: {
                    Text(LocalizedStringKey(section.rawValue))
                })
            }
        } label: {
            Image(Icons.arrowDown.rawValue)
                .resizable()
                .scaledToFill()
                .foregroundColor(Color(ComponentColor.mainText.rawValue))
                .frame(maxWidth: 55, maxHeight: 50)
        }
    }
}

struct SectionSwitch_Previews: PreviewProvider {
    static var previews: some View {
        SectionSwitch()
    }
}
