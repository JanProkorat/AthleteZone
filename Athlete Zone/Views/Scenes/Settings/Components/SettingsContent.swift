//
//  SettingsContent.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 10.11.2022.
//

import SwiftUI

struct SettingsContent: View {
    @StateObject var appStorageManager = AppStorageManager.shared
    @EnvironmentObject var viewModel: WorkOutViewModel

    var body: some View {
        VStack(spacing: 5) {
            SettingsItem(title: "Language", content: {
                LanguagePicker()
            })
            .padding(.top, 20)

            SettingsItem(title: "Sounds", content: {
                Toggle("", isOn: appStorageManager.$soundsEnabled)
                    .frame(width: 0)
                    .padding(.trailing, 30)
            })

            SettingsItem(title: "Haptics (Watch only)", content: {
                Toggle("", isOn: appStorageManager.$hapticsEnabled)
                    .frame(width: 0)
                    .padding(.trailing, 30)
            })

            SettingsItem(title: "Remind me workout", content: {
                Toggle("", isOn: appStorageManager.$notificationsEnabled)
                    .frame(width: 0)
                    .padding(.trailing, 30)
            })

            Spacer()
        }
        .onChange(of: appStorageManager.language) { newValue in
            self.viewModel.shareLanguage(newValue)
        }
        .onChange(of: appStorageManager.soundsEnabled) { newValue in
            self.viewModel.shareSoundsEnabled(newValue)
        }
        .onChange(of: appStorageManager.hapticsEnabled) { newValue in
            self.viewModel.shareHapticsEnabled(newValue)
        }
        .onChange(of: appStorageManager.notificationsEnabled) { self.viewModel.handleNotifications($0) }
    }
}

struct SettingsContent_Previews: PreviewProvider {
    static var previews: some View {
        SettingsContent()
            .environmentObject(WorkOutViewModel())
    }
}
