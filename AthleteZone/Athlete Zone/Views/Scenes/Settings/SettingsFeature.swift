//
//  SettingsFeature.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 26.02.2024.
//

import ComposableArchitecture
import Foundation
import HealthKit

@Reducer
struct SettingsFeature {
    @ObservableState
    struct State {
        var isSubscriptionActive = false
        var language: Language = .en
        var soundsEnabled = false
        var notificationsEnabled = false
        var runInBackground = false
        var hapticsEnabled = false
        var healthKitAccess = false
        var hkAuthStatus: HKAuthorizationStatus = .notDetermined
        var watchAppInstalled = false
    }

    enum Action {
        case onAppear
        case languageChanged(Language)
        case soundsChanged(Bool)
        case notificationsChanged(Bool)
        case backgroundRunChanged(Bool)
        case hapticsChanged(Bool)
        case healthKitAccessChanged(Bool)
        case watchAppInstalledChanged(Bool)
        case subscriptionSheetVisibilityChanged
        case subscriptionChanged(Bool)
        case delegate(Delegate)

        // swiftlint:disable nesting
        enum Delegate: Equatable {
            case seubscriptionSheetVisibilityChanged
            case languageChanged(Language)
        }
        // swiftlint:enable nesting
    }

    @Dependency(\.appStorageManager) var appStorageManager
    @Dependency(\.watchConnectivityManager) var connectivityManager
    @Dependency(\.healthManager) var healthManager
    @Dependency(\.notificationManager) var notificationManager
    @Dependency(\.subscriptionManager) var subscriptionManager
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    await send(.languageChanged(appStorageManager.language))
                    await send(.soundsChanged(appStorageManager.soundsEnabled))
                    await send(.notificationsChanged(appStorageManager.notificationsEnabled))
                    await send(.backgroundRunChanged(appStorageManager.runInBackground))
                    await send(.hapticsChanged(appStorageManager.hapticsEnabled))
                    await send(.subscriptionChanged(subscriptionManager.subscriptionActivated))
                    await send(.watchAppInstalledChanged(connectivityManager.checkIfPairedAppInstalled()
                    ))
                }

            case .delegate:
                return .none

            case .languageChanged(let language):
                if language == state.language {
                    return .none
                }
                state.language = language
                connectivityManager.sendValue([TransferDataKey.language.rawValue: language.rawValue])
                appStorageManager.language = language
                return .send(.delegate(.languageChanged(language)))

            case .soundsChanged(let enabled):
                state.soundsEnabled = enabled
                connectivityManager.sendValue([TransferDataKey.soundsEnabled.rawValue: enabled])
                return .none

            case .notificationsChanged(let enabled):
                if enabled == state.notificationsEnabled {
                    return .none
                }
                if enabled {
                    notificationManager.allowNotifications()
                } else {
                    notificationManager.removeNotification()
                }
                state.notificationsEnabled = enabled
                return .none

            case .backgroundRunChanged(let enabled):
                state.runInBackground = enabled
                appStorageManager.runInBackground = enabled
                return .none

            case .hapticsChanged(let enabled):
                state.hapticsEnabled = enabled
                connectivityManager.sendValue([TransferDataKey.hapticsEnabled.rawValue: enabled])
                return .none

            case .watchAppInstalledChanged(let installed):
                state.watchAppInstalled = installed
                return .none

            case .healthKitAccessChanged(let enabled):
                if !enabled {
                    return .none
                }
                let status = healthManager.checkAuthorizationStatus()
                if status == .sharingAuthorized {
                    return .none
                }
                healthManager.requestAuthorization()
                return .none

            case .subscriptionSheetVisibilityChanged:
                return .send(.delegate(.seubscriptionSheetVisibilityChanged))

            case .subscriptionChanged(let active):
                state.isSubscriptionActive = active
                return .none
            }
        }
    }
}
