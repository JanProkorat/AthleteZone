//
//  WorkOutContentViewModelTests.swift
//  Athlete Zone Tests
//
//  Created by Jan Prokorát on 21.07.2023.
//

import Foundation

@testable import Athlete_Zone
import Nimble
import XCTest

final class WorkOutContentViewModelTests: XCTestCase {
    var viewModel: WorkOutContentViewModel!

    override func setUp() {
        super.setUp()
        viewModel = WorkOutContentViewModel()
        viewModel.router = ViewRouterMock()
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testCurrentTabUpdatesCorrectly() {
        // Given
        let expectedTab: Tab = .settings

        // When
        viewModel.router.currentTab = expectedTab

        // Then
        expect(self.viewModel.currentTab) == expectedTab
    }
}
