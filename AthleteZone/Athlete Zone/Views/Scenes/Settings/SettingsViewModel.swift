//
//  SettingsViewModel.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 03.03.2023.
//

import Combine
import Foundation
 import HealthKit
import SwiftUI

class SettingsViewModel: ObservableObject {
    @Published var appStorageManager = AppStorageManager.shared
    @Published var languageManager = LanguageManager.shared
    var healthManager = HealthManager.shared

    @ObservedObject var router = ViewRouter.shared
    @ObservedObject var subscriptionManager = SubscriptionManager.shared

    var connectivityManager: WatchConnectivityProtocol
    private let notificationManager = NotificationManager.shared
    private var cancellables = Set<AnyCancellable>()

    @Published var healthKitAccess = false
    @Published var hkAuthStatus: HKAuthorizationStatus = .notDetermined

    @Published var subscriptionActive = false

    init() {
        connectivityManager = WatchConnectivityManager.shared

        appStorageManager.objectWillChange
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.shareLanguage(self.appStorageManager.language)
                self.shareSoundsEnabled(self.appStorageManager.soundsEnabled)
                self.shareHapticsEnabled(self.appStorageManager.hapticsEnabled)
                self.handleNotifications(self.appStorageManager.notificationsEnabled)
            }
            .store(in: &cancellables)

        $healthKitAccess
            .sink { self.grantAccess($0) }
            .store(in: &cancellables)

        healthManager.$hkAccessStatus
            .sink { newValue in
                self.hkAuthStatus = newValue
                if newValue == .sharingAuthorized {
                    self.healthKitAccess = true
                } else {
                    self.healthKitAccess = false
                }
            }
            .store(in: &cancellables)

        subscriptionManager.$subscriptionActivated
            .sink { isActivated in
                self.subscriptionActive = isActivated
            }
            .store(in: &cancellables)
    }

    func grantAccess(_ access: Bool) {
        if !access {
            return
        }

        let status = healthManager.checkAuthorizationStatus()
        if status == .sharingAuthorized {
            return
        }

        healthManager.requestAuthorization()
    }

    func shareLanguage(_ language: Language) {
        connectivityManager.sendValue([TransferDataKey.language.rawValue: language.rawValue])
    }

    func shareSoundsEnabled(_ enabled: Bool) {
        connectivityManager.sendValue([TransferDataKey.soundsEnabled.rawValue: enabled])
    }

    func shareHapticsEnabled(_ enabled: Bool) {
        connectivityManager.sendValue([TransferDataKey.hapticsEnabled.rawValue: enabled])
    }

    func handleNotifications(_ isEnabled: Bool) {
        if isEnabled {
            notificationManager.allowNotifications()
        } else {
            notificationManager.removeNotification()
        }
    }
}
