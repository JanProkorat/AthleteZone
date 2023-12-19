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
            detailedPanel(
                title: LocalizationKey.premiumSubscription,
                description: LocalizationKey.subscriptionDescription)
            {
                Button {
                    viewModel.subscriptionManager.isSubscriptionViewVisible.toggle()
                } label: {
                    Text(viewModel.subscriptionActive ?
                        LocalizationKey.active.localizedKey :
                        LocalizationKey.activate.localizedKey)
                        .font(.subheadline)
                        .bold()
                        .foregroundStyle(Color(ComponentColor.mainText.rawValue))
                        .padding(8)
                }
                .frame(width: 100)
                .disabled(viewModel.subscriptionActive)
                .roundedBackground(
                    cornerRadius: 15,
                    color: viewModel.subscriptionActive ? .grey : .accent)
            }
            .padding(.top, 20)

            SettingsItem(title: LocalizationKey.language, content: {
                LanguagePicker(selectedLanguage: $viewModel.languageManager.language)
            })

            SettingsItem(title: LocalizationKey.sounds, content: {
                toggle(value: $viewModel.appStorageManager.soundsEnabled)
            })

            SettingsItem(title: LocalizationKey.allowNotifications, content: {
                toggle(value: $viewModel.appStorageManager.notificationsEnabled)
            })

            detailedPanel(
                title: LocalizationKey.runInBackground,
                description: LocalizationKey.runInBackgroundDescription)
            {
                toggle(value: $viewModel.appStorageManager.runInBackground)
            }

            if isWatchInstalled {
                SettingsItem(title: LocalizationKey.haptics, content: {
                    toggle(value: $viewModel.appStorageManager.hapticsEnabled)
                })

                detailedPanel(
                    title: LocalizationKey.healthKitAccess,
                    description: viewModel.hkAuthStatus == .sharingAuthorized ?
                        LocalizationKey.healthKitAccessDescription1 :
                        LocalizationKey.healthKitAccessDescription2)
                {
                    toggle(value: $viewModel.healthKitAccess)
                }
                .disabled(viewModel.hkAuthStatus != .notDetermined)
                .animation(.easeInOut, value: viewModel.hkAuthStatus)
            }

            Spacer()
        }
        .onAppear {
            isWatchInstalled = viewModel.connectivityManager.checkIfPairedAppInstalled()
        }
    }

    @ViewBuilder
    func toggle(value: Binding<Bool>) -> some View {
        Toggle("", isOn: value)
            .frame(width: 0)
            .padding(.trailing, 30)
    }

    @ViewBuilder
    func detailedPanel<Content: View>(title: LocalizationKey, description: LocalizationKey, content: @escaping () -> Content) -> some View {
        VStack {
            SettingsItem(title: title, content: {
                content()
            })

            Text(description.localizedKey)
                .padding([.leading, .trailing], 20)
                .padding(.top, -10)
                .font(.footnote)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.bottom)
        .roundedBackground(cornerRadius: 20)
    }
}

struct SettingsContent_Previews: PreviewProvider {
    static var previews: some View {
        SettingsContent()
            .environmentObject(SettingsViewModel())
    }
}
