//
//  ContentViewModelTests.swift
//  Athlete Zone Watch App Tests
//
//  Created by Jan Prokorát on 22.11.2023.
//

@testable import Athlete_Zone_Mini
import Nimble
import XCTest

class ContentViewModelTests: XCTestCase {
    var viewModel: ContentViewModel!

    override func setUpWithError() throws {
        try super.setUpWithError()

        // Create and inject the mocked dependencies
        viewModel = ContentViewModel()
//        viewModel.router = ViewRouterMock()
//        viewModel.notificationManager = NotificationManagerMock()
//        viewModel.languageManager = LanguageManagerMock()
//        viewModel.appStorageManager = AppStorageManagerMock()
    }

    override func tearDownWithError() throws {
        viewModel = nil
        try super.tearDownWithError()
    }
}
