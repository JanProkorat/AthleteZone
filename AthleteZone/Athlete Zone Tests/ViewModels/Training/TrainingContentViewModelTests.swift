//
//  TrainingContentViewModelTests.swift
//  Athlete Zone Tests
//
//  Created by Jan Prokorát on 21.11.2023.
//

@testable import Athlete_Zone
import Nimble
import XCTest

class TrainingContentViewModelTests: XCTestCase {
    var viewModel: TrainingContentViewModel!
    var router: ViewRouterMock!

    override func setUp() {
        super.setUp()
        viewModel = TrainingContentViewModel()
        router = ViewRouterMock()
        viewModel.router = router
    }

    override func tearDown() {
        viewModel = nil
        router = nil
        super.tearDown()
    }

    func testCurrentTabUpdatesCorrectly() {
        // Given
        let expectedTab: Tab = .setting

        // When
        router.currentTab = expectedTab

        // Then
        expect(self.viewModel.currentTab).to(equal(expectedTab))
    }
}
