//
//  TrainingRunViewModelTests.swift
//  Athlete Zone Tests
//
//  Created by Jan Prokorát on 21.11.2023.
//

@testable import Athlete_Zone
import Nimble
import XCTest

class TrainingRunViewModelTests: XCTestCase {
    var viewModel: TrainingRunViewModel!

    override func setUp() {
        super.setUp()
        viewModel = TrainingRunViewModel()
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testCloseSheet() {
        // Act
        viewModel.selectedWorkFlowViewModel.setState(.quit)

        // Assert
        expect(self.viewModel.closeSheet).to(beTrue())
    }
}
