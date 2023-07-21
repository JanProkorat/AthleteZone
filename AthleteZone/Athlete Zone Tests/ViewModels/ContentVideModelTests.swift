//
//  ContentVideModelTests.swift
//  Athlete Zone Tests
//
//  Created by Jan Prokorát on 21.07.2023.
//

@testable import Athlete_Zone
import Combine
import Nimble
import XCTest

class ContentViewModelTests: XCTestCase {
    var viewModel: ContentViewModel!
    var router: ViewRouter!
    var notificationManager: NotificationManager!
    var languageManager: LanguageManager!
    var appStorageManager: AppStorageManager!

    override func setUp() {
        super.setUp()

        // Create and inject the mocked dependencies
        router = ViewRouter.shared
        notificationManager = NotificationManager.shared
        languageManager = LanguageManager.shared
        appStorageManager = AppStorageManager.shared

        viewModel = ContentViewModel()
        viewModel.router = router
        viewModel.notificationManager = notificationManager
        viewModel.languageManager = languageManager
        viewModel.appStorageManager = appStorageManager
    }

    override func tearDown() {
        viewModel = nil
        router = nil
        notificationManager = nil
        languageManager = nil
        appStorageManager = nil
        super.tearDown()
    }

    func testCurrentSectionUpdatesRouterAndAppStorageManager() {
        // Given
        let expectedSection: Section = .training

        // When
        viewModel.currentSection = expectedSection

        // Then
        expect(self.router.currentSection) == expectedSection
        expect(self.appStorageManager.selectedSection) == expectedSection
    }

    func testLanguageManagerUpdatesAppStorageManagerAndCurrentLanguage() {
        // Given
        let expectedLanguage: Language = .cze

        // When
        viewModel.languageManager.language = expectedLanguage

        // Then
        expect(self.appStorageManager.language) == expectedLanguage
        expect(self.viewModel.currentLanguage) == expectedLanguage
    }

    func testNotificationsEnabledAllowNotifications() {
        // Given
        appStorageManager.notificationsEnabled = true

        // When
        viewModel = ContentViewModel()

        // Then
        expect(self.appStorageManager.notificationsEnabled) == true
    }
}
