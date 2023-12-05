//
//  ContentViewModel.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 17.07.2023.
//

import Combine
import Foundation
import SwiftUI
import WidgetKit

class ContentViewModel: ObservableObject {
    var router: any ViewRoutingProtocol {
        didSet { setupSectionWatcher() }
    }

    var languageManager: any LanguageProtocol {
        didSet { setupLanguageWatcher() }
    }

    var notificationManager: NotiificationProtocol
    var appStorageManager: any AppStorageProtocol

    @Published var currentSection: Section = .workout
    @Published var currentLanguage: Language = .en

    private var routerCancellable: AnyCancellable?
    private var languageCancellable: AnyCancellable?

    private var cancellables = Set<AnyCancellable>()

    init() {
        appStorageManager = AppStorageManager.shared
        languageManager = LanguageManager.shared
        notificationManager = NotificationManager.shared
        router = ViewRouter.shared

        if appStorageManager.notificationsEnabled {
            notificationManager.allowNotifications()
        }

        router.currentSection = appStorageManager.selectedSection
        languageManager.language = appStorageManager.language

        setupSectionWatcher()
        setupLanguageWatcher()
    }

    private func setupSectionWatcher() {
        routerCancellable?.cancel()

        routerCancellable = router.currentSectionPublisher
            .sink { newValue in
                self.currentSection = newValue
                self.appStorageManager.selectedSection = newValue
                WidgetCenter.shared.reloadTimelines(ofKind: UserDefaultValues.widgetId.rawValue)
            }
    }

    private func setupLanguageWatcher() {
        languageCancellable?.cancel()

        languageCancellable = languageManager.languagePublisher
            .sink { newValue in
                if newValue != self.appStorageManager.language {
                    self.appStorageManager.language = newValue
                }
                self.currentLanguage = newValue
            }
    }
}
