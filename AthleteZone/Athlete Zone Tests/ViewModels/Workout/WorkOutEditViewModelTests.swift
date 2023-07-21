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

    override func setUp() {
        viewModel = WorkOutEditViewModel()
        viewModel.realmManager = WorkOutRealmManagerMock()
    }

    override func tearDown() {
        viewModel = nil
    }

    func testTimeOverviewCalculation() {
        // Given
        viewModel.work = 40
        viewModel.rest = 70
        viewModel.series = 5
        viewModel.rounds = 3
        viewModel.reset = 60

        // When
        let expectedTimeOverview = (((40 * 5) + (70 * (5 - 1)) + 60) * 3) - 60

        // Then
        XCTAssertEqual(viewModel.timeOverview, expectedTimeOverview)
    }

    func testSaveDisabled() {
        // When
        viewModel.name = ""

        // Then
        XCTAssertEqual(viewModel.saveDisabled, true)

        // When
        viewModel.name = "tests"

        // Then
        XCTAssertEqual(viewModel.saveDisabled, false)
    }

    func testSaveWorkout() {
        // Given
        let workout = WorkOut()
        viewModel.workout = workout

        // When
        viewModel.saveWorkout()

        // Then
        XCTAssertNotNil(viewModel.realmManager.load(primaryKey: workout._id.stringValue))
        XCTAssertEqual(viewModel.selectedWorkoutManager.selectedWorkout?._id, workout._id)
    }

    func testSaveWorkoutWhileEditing() {
        // Given
        let workout = WorkOut()
        viewModel.workout = workout
        viewModel.saveWorkout()

        viewModel.isEditing = true
        viewModel.name = "Test Workout Edited"
        viewModel.work = 50
        viewModel.rest = 60
        viewModel.series = 4
        viewModel.rounds = 3
        viewModel.reset = 40

        // When
        viewModel.saveWorkout()
        let result = viewModel.realmManager.load(primaryKey: workout._id.stringValue)
        // Then
        XCTAssertEqual(result?.name, viewModel.name)
        XCTAssertEqual(result?.work, viewModel.work)
        XCTAssertEqual(result?.rest, viewModel.rest)
        XCTAssertEqual(result?.series, viewModel.series)
        XCTAssertEqual(result?.rounds, viewModel.rounds)
        XCTAssertEqual(result?.reset, viewModel.reset)
    }
}
