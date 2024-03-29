//
//  SettingsItem.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 14.02.2023.
//

import SwiftUI

struct SettingsItem<Content: View>: View {
    let content: Content

    var title: LocalizationKey

    init(title: LocalizationKey, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.title = title
    }

    var body: some View {
        HStack(alignment: .center, spacing: 5) {
            Text(title.localizedKey)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(Color(ComponentColor.mainText.rawValue))
                .font(.title3)
                .padding(.leading)
                .lineLimit(1)

            content
                .padding()
        }
        .frame(height: 60)
        .roundedBackground(cornerRadius: 20)
        .frame(maxWidth: .infinity)
    }
}

struct SettingsItem_Previews: PreviewProvider {
    static var previews: some View {
        SettingsItem(title: .haptics) {
            Text("test")
        }
    }
}
