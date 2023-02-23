//
//  SettingsItem.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 14.02.2023.
//

import SwiftUI

struct SettingsItem<Content: View>: View {
    let content: Content

    var title: String

    init(title: String, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.title = title
    }

    var body: some View {
        HStack(alignment: .center, spacing: 5) {
            Text(LocalizedStringKey(title))
                .frame(height: 80)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(Color(ComponentColor.mainText.rawValue))
                .font(.title)
                .padding(.leading)
                .lineLimit(1)

            content
                .padding()
        }
        .background(
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(Color(ComponentColor.menu.rawValue))
        )
        .frame(maxWidth: .infinity)
    }
}

struct SettingsItem_Previews: PreviewProvider {
    static var previews: some View {
        SettingsItem(title: "Haptik aktivieren (nur Uhr") {
            Text("test")
        }
    }
}
