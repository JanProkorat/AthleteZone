//
//  TrainingViewModelTests.swift
//  Athlete Zone Tests
//
//  Created by Jan Prokorát on 21.11.2023.
//

@testable import Athlete_Zone
import Nimble
import XCTest

class TrainingViewModelTests: XCTestCase {
    var viewModel: TrainingViewModel!
    var router: ViewRouterMock!
    var appStorageManager: AppStorageManagerMock!

    override func setUp() {
        super.setUp()
        viewModel = TrainingViewModel()
        router = ViewRouterMock()
        appStorageManager = AppStorageManagerMock()

        viewModel.router = router
        viewModel.appStorageManager = appStorageManager
    }

    override func tearDown() {
        viewModel = nil
        router = nil
        appStorageManager = nil
        super.tearDown()
    }

    func testSetupRunViewModel() {
        // Set up
        let training = Training(name: "Training", description: "test", workouts: [WorkOut()])
        viewModel.selectedTraining = training

        // Act
        viewModel.setupRunViewModel()

        // Assert
        expect(self.viewModel.isRunViewVisible).to(beTrue())
        expect(self.viewModel.runViewModel.trainingName).to(equal(training.name))
        expect(self.viewModel.runViewModel.closeSheet).to(beFalse())
    }

    func testStoreWidgetData() {
        // Set up
        let training = Training(name: "Training", description: "test", workouts: [WorkOut()])
        viewModel.selectedTraining = training

        // Act
        viewModel.storeWidgetData()

        // Assert
        expect(self.appStorageManager.loadFromDefaults(key: .trainingId)).notTo(beNil())
    }
}
