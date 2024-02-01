//
//  WorkOutEditViewModelTests.swift
//  Athlete Zone Tests
//
//  Created by Jan Prokorát on 18.03.2023.
//

@testable import Athlete_Zone
import Nimble
import XCTest

class WorkOutEditViewModelTests: XCTestCase {
    var viewModel: WorkOutEditViewModel!
    var connectivityManager: WatchConnectivityMock!
    var router: ViewRouterMock!

    override func setUp() {
        super.setUp()

        connectivityManager = WatchConnectivityMock()
        router = ViewRouterMock()

        viewModel = WorkOutEditViewModel()
        viewModel.realmManager = WorkOutRealmManagerMock()
        viewModel.connectivityManager = connectivityManager
        viewModel.router = router
    }

    override func tearDown() {
        viewModel = nil
        connectivityManager = nil

        super.tearDown()
    }

    func testTimeOverviewCalculation() {
        // Given
        viewModel.work = 40
        viewModel.rest = 70
        viewModel.series = 5
        viewModel.rounds = 3
        viewModel.reset = 60

        // When
        let expectedTimeOverview = (((40 * 5) + (70 * 5) + 60) * 3) - 60

        // Then
        expect(self.viewModel.timeOverview).to(equal(expectedTimeOverview))
    }

    func testSaveDisabled() {
        // When
        viewModel.name = ""

        // Then
        expect(self.viewModel.saveDisabled).to(beTrue())

        // When
        viewModel.name = "tests"

        // Then
        expect(self.viewModel.saveDisabled).to(beFalse())
    }

    func testSaveWorkout() {
        // Given
        let workout = WorkOut()
        viewModel.workout = workout

        // When
        viewModel.saveWorkout()

        // Then
        expect(
            self.connectivityManager.lastSentMessage?
                .first(where: { $0.key == TransferDataKey.workoutAdd.rawValue })).notTo(beNil())
        expect(self.router.currentTab).to(equal(.home))
    }

    func testSaveWorkoutWhileEditing() {
        // Given
        let workout = WorkOut()
        viewModel.realmManager.add(workout)
        viewModel.workout = workout

        viewModel.isEditing = true
        viewModel.name = "Test Workout Edited"
        viewModel.work = 50
        viewModel.rest = 60
        viewModel.series = 4
        viewModel.rounds = 3
        viewModel.reset = 40

        // When
        viewModel.saveWorkout()

        // Then
        let result = viewModel.realmManager.load(primaryKey: workout._id.stringValue)
        expect(result?.name).to(equal(viewModel.name))
        expect(result?.work).to(equal(viewModel.work))
        expect(result?.rest).to(equal(viewModel.rest))
        expect(result?.series).to(equal(viewModel.series))
        expect(result?.rounds).to(equal(viewModel.rounds))
        expect(result?.reset).to(equal(viewModel.reset))
    }
}
