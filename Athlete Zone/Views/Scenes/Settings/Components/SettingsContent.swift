//
//  SettingsContent.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 10.11.2022.
//

import SwiftUI

struct SettingsContent: View {
    @AppStorage(DefaultItem.language.rawValue) private var language: Language = .en
    @AppStorage(DefaultItem.soundsEnabled.rawValue) private var soundsEnabled = true

    let languages = [
        LanguageSettingConfig(id: .cze, icon: Icons.FlagCZ),
        LanguageSettingConfig(id: .de, icon: Icons.FlagDE),
        LanguageSettingConfig(id: .en, icon: Icons.FlagGB)
    ]

    var body: some View {
        VStack(spacing: 5) {
            HStack(alignment: .center, spacing: 5) {
                Text("Language")
                    .frame(height: 80)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(Color(ComponentColor.mainText.rawValue))
                    .font(.custom("Lato-Bold", size: 25))
                    .padding(.leading)
                HStack(alignment: .center, spacing: 5) {
                    ForEach(languages) { item in
                        IconButton(
                            id: "\(item.id)",
                            image: item.icon,
                            color: .none,
                            width: 40,
                            height: 35,
                            selected: self.language == item.id
                        )
                        .onTab {
                            self.language = item.id
                        }
                        .padding(.leading, 5)
                    }
                }
                .padding()
            }
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(Color(ComponentColor.menu.rawValue))
            )
            .frame(maxWidth: .infinity)
            .padding(.top, 20)

            HStack(alignment: .center, spacing: 5) {
                Toggle("Enable sounds", isOn: $soundsEnabled)
                    .frame(height: 80)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(Color(ComponentColor.mainText.rawValue))
                    .font(.custom("Lato-Bold", size: 25))
                    .padding([.leading, .trailing])
            }
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(Color(ComponentColor.menu.rawValue))
            )
            .frame(maxWidth: .infinity)
            Spacer()
        }
    }
}

struct SettingsContent_Previews: PreviewProvider {
    static var previews: some View {
        SettingsContent()
    }
}
