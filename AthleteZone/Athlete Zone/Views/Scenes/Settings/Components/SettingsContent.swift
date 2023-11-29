//
//  SettingsContent.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 10.11.2022.
//

import SwiftUI

struct SettingsContent: View {
    @EnvironmentObject var viewModel: SettingsViewModel

    @State var isWatchInstalled = false

    var body: some View {
        VStack(spacing: 5) {
            SettingsItem(title: LocalizationKey.language, content: {
                LanguagePicker(selectedLanguage: $viewModel.languageManager.language)
            })
            .padding(.top, 20)

            SettingsItem(title: LocalizationKey.sounds, content: {
                Toggle("", isOn: $viewModel.appStorageManager.soundsEnabled)
                    .frame(width: 0)
                    .padding(.trailing, 30)
            })

            SettingsItem(title: LocalizationKey.allowNotifications, content: {
                Toggle("", isOn: $viewModel.appStorageManager.notificationsEnabled)
                    .frame(width: 0)
                    .padding(.trailing, 30)
            })

            if isWatchInstalled {
                SettingsItem(title: LocalizationKey.haptics, content: {
                    Toggle("", isOn: $viewModel.appStorageManager.hapticsEnabled)
                        .frame(width: 0)
                        .padding(.trailing, 30)
                })

                VStack {
                    SettingsItem(title: LocalizationKey.healthKitAccess, content: {
                        Toggle("", isOn: $viewModel.healthKitAccess)
                            .frame(width: 0)
                            .padding(.trailing, 30)
                    })

                    Text(viewModel.hkAuthStatus == .sharingAuthorized ?
                        LocalizationKey.healthKitAccessDescription1.localizedKey :
                        viewModel.hkAuthStatus == .sharingDenied ?
                        LocalizationKey.healthKitAccessDescription2.localizedKey : "")
                        .padding([.leading, .trailing, .bottom])
                }
                .roundedBackground(cornerRadius: 20)
                .disabled(viewModel.hkAuthStatus != .notDetermined)
                .animation(.easeInOut, value: viewModel.hkAuthStatus)
            }

            Spacer()
        }
        .onAppear {
            isWatchInstalled = viewModel.connectivityManager.checkIfPairedAppInstalled()
        }
    }
}

struct SettingsContent_Previews: PreviewProvider {
    static var previews: some View {
        SettingsContent()
            .environmentObject(SettingsViewModel())
    }
}
