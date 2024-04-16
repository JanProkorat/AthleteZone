////
////  ContentVideModelTests.swift
////  Athlete Zone Tests
////
////  Created by Jan Prokorát on 21.07.2023.
////
//
// @testable import Athlete_Zone
// import Nimble
// import XCTest
//
// class ContentViewModelTests: XCTestCase {
//    var viewModel: ContentViewModel!
//
//    override func setUpWithError() throws {
//        try super.setUpWithError()
//
//        // Create and inject the mocked dependencies
//        viewModel = ContentViewModel()
//        viewModel.router = ViewRouterMock()
//        viewModel.notificationManager = NotificationManagerMock()
//        viewModel.languageManager = LanguageManagerMock()
//        viewModel.appStorageManager = AppStorageManagerMock()
//    }
//
//    override func tearDownWithError() throws {
//        viewModel = nil
//        try super.tearDownWithError()
//    }
//
//    func testCurrentSectionUpdatesRouterAndAppStorageManager() {
//        // Given
//        let expectedSection: Section = .training
//
//        // When
//        viewModel.router.currentSection = expectedSection
//
//        // Then
//        expect(self.viewModel.currentSection) == expectedSection
//        expect(self.viewModel.appStorageManager.selectedSection) == expectedSection
//    }
//
//    func testLanguageManagerUpdatesAppStorageManagerAndCurrentLanguage() {
//        // Given
//        let expectedLanguage: Language = .cze
//
//        // When
//        viewModel.languageManager.language = expectedLanguage
//
//        // Then
//        expect(self.viewModel.appStorageManager.language) == expectedLanguage
//        expect(self.viewModel.currentLanguage) == expectedLanguage
//    }
// }
