//
//  TitleText.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 17.12.2022.
//

import SwiftUI

struct TitleText: View {
    let text: String
    let alignment: Alignment

    init(text: String, alignment: Alignment) {
        self.text = text
        self.alignment = alignment
    }

    init(text: String) {
        self.text = text
        self.alignment = .leading
    }

    var body: some View {
        Text(LocalizedStringKey(text))
            .font(.largeTitle)
            .foregroundColor(Color(ComponentColor.mainText.rawValue))
            .frame(maxWidth: .infinity, alignment: alignment)
    }
}

struct TitleText_Previews: PreviewProvider {
    static var previews: some View {
        TitleText(text: LocalizationKey.actions.rawValue)
    }
}
