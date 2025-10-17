//
//  AppStateManager.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 14.01.2025.
//

import ComposableArchitecture
import Foundation

// Class holding current state of the app - current tab, title, language, subscription etc.
class AppStateManager: ObservableObject {
    static let shared = AppStateManager()

    @Published var currentTab: Tab = .home
    @Published var title: String = ""
    @Published var language: Language = .en
    @Published var timeTrackingType: TimerType = .stopWatch
    @Published var isSubscriptionSheetVisible = false
    @Published var isSubscriptionActive = false
    @Published var saveTapped = false

    func updateTab(_ tab: Tab) {
        if tab == self.currentTab {
            return
        }
        self.currentTab = tab
    }

    func updateTitle(_ title: String) {
        if title == self.title {
            return
        }
        self.title = title
    }

    func updateLanguage(_ language: Language) {
        if language == self.language {
            return
        }
        self.language = language
    }

    func updateIsSubscriptionSheetVisible() {
        self.isSubscriptionSheetVisible.toggle()
    }

    func updateIsSubsccriptionActive(_ isActive: Bool) {
        self.isSubscriptionActive = isActive
    }

    func updateTimeTrackingType(_ timeTrackingType: TimerType) {
        if timeTrackingType == self.timeTrackingType {
            return
        }
        self.timeTrackingType = timeTrackingType
    }

    func updateSaveTapped(_ tapped: Bool) {
        self.saveTapped = tapped
    }
}

extension AppStateManager: DependencyKey {
    static var liveValue: AppStateManager = .shared
    static var testValue: AppStateManager = .shared
}
