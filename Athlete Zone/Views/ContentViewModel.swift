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
    @ObservedObject var router = ViewRouter.shared
    @ObservedObject var notificationManager = NotificationManager.shared
    @ObservedObject var languageManager = LanguageManager.shared

    @Published var currentSection: Section = .workout
    @Published var currentLanguage: Language = .en

    private var cancellables = Set<AnyCancellable>()
    private var appStorageManager = AppStorageManager.shared

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
