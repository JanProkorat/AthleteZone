//
//  SettingsView.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 26.02.2024.
//

import ComposableArchitecture
import SwiftUI

struct SettingsView: View {
    @Bindable var store: StoreOf<SettingsFeature>

    var body: some View {
        VStack(spacing: 5) {
            detailedPanel(
                title: LocalizationKey.premiumSubscription,
                description: LocalizationKey.subscriptionDescription)
            {
                Button {
                    store.send(.subscriptionSheetVisibilityChanged)
                } label: {
                    Text(store.isSubscriptionActive ?
                        LocalizationKey.active.localizedKey :
                        LocalizationKey.activate.localizedKey)
                        .font(.subheadline)
                        .bold()
                        .foregroundStyle(Color(ComponentColor.mainText.rawValue))
                        .padding(8)
                }
                .frame(width: 100)
                .disabled(store.isSubscriptionActive)
                .roundedBackground(
                    cornerRadius: 15,
                    color: store.isSubscriptionActive ? .grey : .accent)
            }

            SettingsItem(title: LocalizationKey.language, content: {
                LanguagePicker(selectedLanguage: $store.language.sending(\.languageChanged))
            })

            detailedPanel(title: LocalizationKey.sounds, description: LocalizationKey.soundsDescription) {
                toggle(value: $store.soundsEnabled.sending(\.soundsChanged))
            }

            detailedPanel(title: LocalizationKey.allowNotifications, description: LocalizationKey.allowNotificationsDescription) {
                toggle(value: $store.notificationsEnabled.sending(\.notificationsChanged))
            }

            detailedPanel(title: LocalizationKey.runInBackground, description: LocalizationKey.runInBackgroundDescription) {
                toggle(value: $store.runInBackground.sending(\.backgroundRunChanged))
            }

            if store.watchAppInstalled {
                SettingsItem(title: LocalizationKey.haptics, content: {
                    toggle(value: $store.hapticsEnabled.sending(\.hapticsChanged))
                })

                detailedPanel(
                    title: LocalizationKey.healthKitAccess,
                    description: store.hkAuthStatus == .sharingAuthorized ?
                        LocalizationKey.healthKitAccessDescription1 :
                        LocalizationKey.healthKitAccessDescription2)
                {
                    toggle(value: $store.healthKitAccess.sending(\.healthKitAccessChanged))
                }
                .disabled(store.hkAuthStatus != .notDetermined)
                .animation(.easeInOut, value: store.hkAuthStatus)
            }

            Spacer()
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

#Preview {
    SettingsView(store: ComposableArchitecture.Store(initialState: SettingsFeature.State(), reducer: {
        SettingsFeature()
            ._printChanges()
    }))
}
