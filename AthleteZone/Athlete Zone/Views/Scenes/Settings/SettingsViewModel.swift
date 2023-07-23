//
//  SettingsViewModel.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 03.03.2023.
//

import Combine
import Foundation
import SwiftUI

class SettingsViewModel: ObservableObject {
    @Published var appStorageManager = AppStorageManager.shared
    @Published var languageManager = LanguageManager.shared

    @ObservedObject var router = ViewRouter.shared

    var connectivityManager: WatchConnectivityProtocol
    private let notificationManager = NotificationManager.shared
    private var cancellables = Set<AnyCancellable>()

    init() {
        self.connectivityManager = WatchConnectivityManager.shared

        appStorageManager.objectWillChange
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.shareLanguage(self.appStorageManager.language)
                self.shareSoundsEnabled(self.appStorageManager.soundsEnabled)
                self.shareHapticsEnabled(self.appStorageManager.hapticsEnabled)
                self.handleNotifications(self.appStorageManager.notificationsEnabled)
            }
            .store(in: &cancellables)
    }

    func shareLanguage(_ language: Language) {
        connectivityManager.sendValue([DefaultItem.language.rawValue: language.rawValue])
    }

    func shareSoundsEnabled(_ enabled: Bool) {
        connectivityManager.sendValue([DefaultItem.soundsEnabled.rawValue: enabled])
    }

    func shareHapticsEnabled(_ enabled: Bool) {
        connectivityManager.sendValue([DefaultItem.hapticsEnabled.rawValue: enabled])
    }

    func handleNotifications(_ isEnabled: Bool) {
        if isEnabled {
            notificationManager.allowNotifications()
        } else {
            notificationManager.removeNotification()
        }
    }
}
