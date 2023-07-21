//
//  ContentViewModel.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 17.07.2023.
//

import Combine
import Foundation
import SwiftUI

class ContentViewModel: ObservableObject {
    var router = ViewRouter.shared
    var notificationManager = NotificationManager.shared
    var languageManager = LanguageManager.shared
    var appStorageManager = AppStorageManager.shared

    @Published var currentSection: Section = .workout
    @Published var currentLanguage: Language = .en

    private var cancellables = Set<AnyCancellable>()

    init() {
        router.currentSection = appStorageManager.selectedSection

        router.$currentSection
            .sink { newValue in
                self.currentSection = newValue
                self.appStorageManager.selectedSection = newValue
            }
            .store(in: &cancellables)

        if appStorageManager.notificationsEnabled {
            notificationManager.allowNotifications()
        }

        languageManager.language = appStorageManager.language

        languageManager.$language
            .sink { newValue in
                if newValue != self.appStorageManager.language {
                    self.appStorageManager.language = newValue
                }
                self.currentLanguage = newValue
            }
            .store(in: &cancellables)
    }
}
