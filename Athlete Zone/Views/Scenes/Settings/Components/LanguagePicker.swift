//
//  LanguagePicker.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 14.02.2023.
//

import SwiftUI

struct LanguagePicker: View {
    @Binding var selectedLanguage: Language

    var body: some View {
        HStack(alignment: .center, spacing: 5) {
            ForEach(Language.allCases, id: \.self) { item in
                Button(action: {
                    selectedLanguage = item
                }, label: {
                    Image(item.rawValue)
                        .resizable()
                        .scaledToFit()
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(selectedLanguage == item ?
                                    Color(ComponentColor.action.rawValue) :
                                    Color(.clear), lineWidth: 4)
                                .frame(width: 40, height: 34)
                        )

                })
                .frame(width: 40, height: 35)
                .padding(.leading, 5)
            }
        }
    }
}

struct LanguagePicker_Previews: PreviewProvider {
    static var previews: some View {
        LanguagePicker(selectedLanguage: Binding.constant(Language.en))
    }
}
