//
//  SettingsView.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 07.11.2022.
//

import SwiftUI

struct SettingsScene: View {
    @EnvironmentObject var viewModel: SettingsViewModel

    var body: some View {
        BaseView(
            header: {
                TitleText(text: LocalizationKey.settings.rawValue)
            },
            content: {
                SettingsContent()
            }
        )
    }
}

struct SettingsScene_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScene()
            .environmentObject(SettingsViewModel())
    }
}
