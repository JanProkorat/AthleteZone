//
//  TrainingLibraryViewModelTests.swift
//  Athlete Zone Tests
//
//  Created by Jan Prokorát on 21.11.2023.
//

@testable import Athlete_Zone
import Nimble
import XCTest

class TrainingLibraryViewModelTests: XCTestCase {
    var viewModel: TrainingLibraryViewModel!
    var realmManager: TrainingRealmManagerMock!
    var router: ViewRouterMock!
    var connectivityManager: WatchConnectivityMock!

    override func setUp() {
        super.setUp()
        viewModel = TrainingLibraryViewModel()
        realmManager = TrainingRealmManagerMock()
        router = ViewRouterMock()
        connectivityManager = WatchConnectivityMock()

        viewModel.realmManager = realmManager
        viewModel.router = router
        viewModel.connectivityManager = connectivityManager
    }

    override func tearDown() {
        viewModel = nil
        realmManager = nil
        router = nil
        connectivityManager = nil
        super.tearDown()
    }

    func testSetSelectedTraining() {
        // Set up
        let training = Training()
        realmManager.add(training)

        // Act
        viewModel.setSelectedTraining(training._id.stringValue)

        // Assert
        expect(self.viewModel.selectedTrainingManager.selectedTraining).to(equal(training))
    }

    func testSetSelectedTraining_byObject() {
        // Set up
        let training = Training()
        realmManager.add(training)

        // Act
        viewModel.setSelectedTraining(training)

        // Assert
        expect(self.viewModel.selectedTrainingManager.selectedTraining).to(equal(training))
    }

    func testRemoveTraining() {
        // Set up
        let training = Training()
        realmManager.add(training)
        viewModel.setSelectedTraining(training)

        // Act
        viewModel.removeTraining(training)

        // Assert
        expect(self.realmManager.load(primaryKey: training._id.stringValue)).to(beNil())
        expect(self.connectivityManager.lastSentMessage?.keys).to(contain("training_remove"))
        expect(self.viewModel.selectedTrainingManager.selectedTraining).to(beNil())
    }
}
