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
    var router: ViewRouter!

    override func setUp() {
        super.setUp()
        viewModel = WorkOutContentViewModel()
        router = ViewRouter.shared
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testCurrentTabUpdatesCorrectly() {
        // Given
        let expectedTab: Tab = .profile

        // When
        router.currentTab = expectedTab

        // Then
        expect(self.viewModel.currentTab) == expectedTab
    }
}
