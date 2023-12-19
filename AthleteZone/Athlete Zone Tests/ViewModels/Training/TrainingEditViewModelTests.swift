//
//  TrainingEditViewModelTests.swift
//  Athlete Zone Tests
//
//  Created by Jan Prokorát on 21.11.2023.
//

@testable import Athlete_Zone
import Nimble
import XCTest

class TrainingEditViewModelTests: XCTestCase {
    var viewModel: TrainingEditViewModel!
    var realmManager: TrainingRealmManagerMock!
    var router: ViewRouterMock!
    var connectivityManager: WatchConnectivityMock!

    override func setUp() {
        super.setUp()
        viewModel = TrainingEditViewModel()
        realmManager = TrainingRealmManagerMock()
        router = ViewRouterMock()
        connectivityManager = WatchConnectivityMock()

        viewModel.trainingRealmManager = realmManager
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

    func testSaveTraining_newTraining() {
        // Set up
        router.currentTab = .home
        viewModel.training = Training()
        let name = "Name"
        let description = "test"
        let workout = WorkOut()

        // Action
        viewModel.name = name
        viewModel.description = description
        viewModel.workouts = [workout]

        // Act
        viewModel.saveTraining()

        // Assert
        expect(self.viewModel.training.name).to(equal(name))
        expect(self.viewModel.training.trainingDescription).to(equal(description))
        expect(self.viewModel.training.workouts).to(contain(workout))
        expect(self.connectivityManager.lastSentMessage?.keys).to(contain(TransferDataKey.trainingAdd.rawValue))
        expect(self.viewModel.selectedTrainingManager.selectedTraining).to(equal(viewModel.training))
    }

    func testSaveTraining_updateTraining() {
        // Set up
        let training = Training(name: "Training", description: "test", workouts: [WorkOut()])
        realmManager.add(training)
        let name = "Name"
        let description = "nevim"
        viewModel.isEditing = true
        viewModel.training = training
        viewModel.name = name
        viewModel.description = description

        // Action
        viewModel.saveTraining()

        // Assert
        expect(self.viewModel.training.name).to(equal(name))
        expect(self.viewModel.training.trainingDescription).to(equal(description))
        expect(self.connectivityManager.lastSentMessage?.keys).to(contain(TransferDataKey.trainingEdit.rawValue))
    }
}
