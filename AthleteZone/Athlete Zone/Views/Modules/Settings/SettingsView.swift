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
    @Environment(\.scenePhase) var scenePhase: ScenePhase

    var body: some View {
        ScrollView {
            VStack(spacing: 5) {
                detailedPanel(title: .premiumSubscription, description: .subscriptionDescription) {
                    Button {
                        store.send(.subscriptionSheetVisibilityChanged)
                    } label: {
                        Text(store.isSubscriptionActive ? LocalizationKey.active.localizedKey : LocalizationKey.activate.localizedKey)
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

                SettingsItem(title: .language, content: {
                    LanguagePicker(selectedLanguage: $store.language.sending(\.languageChanged))
                })

                detailedPanel(title: .sounds, description: .soundsDescription) {
                    toggle(value: $store.soundsEnabled.sending(\.soundsChanged))
                }

                detailedPanel(title: .allowNotifications, description: .allowNotificationsDescription) {
                    toggle(value: $store.notificationsEnabled.sending(\.notificationsChanged))
                }

                detailedPanel(title: .runInBackground, description: .runInBackgroundDescription) {
                    toggle(value: $store.runInBackground.sending(\.backgroundRunChanged))
                }

                if store.watchAppInstalled {
                    detailedPanel(title: .haptics, description: .hapticsDescription) {
                        toggle(value: $store.hapticsEnabled.sending(\.hapticsChanged))
                    }

                    detailedPanel(title: .healthKitAccess, description: getHealthKitDescription()) {
                        toggle(value: $store.healthKitAccess.sending(\.healthKitAccessChanged))
                    }
                    .disabled(store.hkAuthStatus != .notDetermined)
                    .animation(.easeInOut, value: store.hkAuthStatus)
                }

                Spacer()
            }
        }
        .onChange(of: scenePhase) { oldValue, newValue in
            if newValue == ScenePhase.active && (oldValue == ScenePhase.inactive || oldValue == ScenePhase.background) {
                store.send(.hkAccessStatusChanged)
            }
        }
    }

    func getHealthKitDescription() -> LocalizationKey {
        switch store.hkAuthStatus {
        case .notDetermined:
            return .healthKitAccessDescription3

        case .sharingDenied:
            return .healthKitAccessDescription2

        case .sharingAuthorized:
            return .healthKitAccessDescription1
        @unknown default:
            return .healthKitAccessDescription1
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
                .lineLimit(2)
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
