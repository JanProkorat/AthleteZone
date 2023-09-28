//
//  SettingsContent.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 10.11.2022.
//

import SwiftUI

struct SettingsContent: View {
    @EnvironmentObject var viewModel: SettingsViewModel

    var body: some View {
        VStack(spacing: 5) {
            SettingsItem(title: "Language", content: {
                LanguagePicker(selectedLanguage: $viewModel.languageManager.language)
            })
            .padding(.top, 20)

            SettingsItem(title: "Sounds", content: {
                Toggle("", isOn: $viewModel.appStorageManager.soundsEnabled)
                    .frame(width: 0)
                    .padding(.trailing, 30)
            })

            SettingsItem(title: "Allow notifications", content: {
                Toggle("", isOn: $viewModel.appStorageManager.notificationsEnabled)
                    .frame(width: 0)
                    .padding(.trailing, 30)
            })

            SettingsItem(title: "Haptics (Watch only)", content: {
                Toggle("", isOn: $viewModel.appStorageManager.hapticsEnabled)
                    .frame(width: 0)
                    .padding(.trailing, 30)
            })

            VStack {
                SettingsItem(title: "HealthKit access", content: {
                    Toggle("", isOn: $viewModel.healthKitAccess)
                        .frame(width: 0)
                        .padding(.trailing, 30)
                })

                HStack {
                    if viewModel.hkAuthStatus == .sharingAuthorized {
                        Text("Removing access can only be done in settings of the Health app")
                            .padding(.bottom)
                    } else if viewModel.hkAuthStatus == .sharingDenied {
                        Text("Access was denied in the settings of the Health app. It can only be reenabled from there")
                            .padding(.bottom)
                    }
                }
                .padding([.leading, .trailing])
            }
            .roundedBackground(cornerRadius: 20)
            .disabled(viewModel.hkAuthStatus != .notDetermined)
            .animation(.easeInOut, value: viewModel.hkAuthStatus)

            Spacer()
        }
    }
}

struct SettingsContent_Previews: PreviewProvider {
    static var previews: some View {
        SettingsContent()
            .environmentObject(SettingsViewModel())
    }
}
