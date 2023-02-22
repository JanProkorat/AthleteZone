//
//  LanguagePicker.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 14.02.2023.
//

import SwiftUI

struct LanguagePicker: View {
    @StateObject var appStorageManager = AppStorageManager.shared

    let languages = [
        LanguageSettingConfig(id: .cze, icon: Icons.flagCZ.rawValue),
        LanguageSettingConfig(id: .de, icon: Icons.flagDE.rawValue),
        LanguageSettingConfig(id: .en, icon: Icons.flagGB.rawValue)
    ]

    var body: some View {
        HStack(alignment: .center, spacing: 5) {
            ForEach(languages) { item in
                IconButton(
                    id: "\(item.id)",
                    image: item.icon,
                    color: .none,
                    width: 40,
                    height: 35,
                    selected: appStorageManager.language == item.id
                )
                .onTab {
                    appStorageManager.language = item.id
                }
                .padding(.leading, 5)
            }
        }
    }
}

struct LanguagePicker_Previews: PreviewProvider {
    static var previews: some View {
        LanguagePicker()
    }
}
