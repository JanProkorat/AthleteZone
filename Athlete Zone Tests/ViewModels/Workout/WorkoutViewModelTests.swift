//
//  WorkoutViewModelTests.swift
//  Athlete Zone Tests
//
//  Created by Jan Prokorát on 08.03.2023.
//

@testable import Athlete_Zone
import Nimble
import XCTest

final class WorkOutViewModelTests: XCTestCase {
    var viewModel: WorkOutViewModel!

    override func setUp() {
        super.setUp()
        viewModel = WorkOutViewModel()
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testTimeOverviewCalculation() {
        // Given
        viewModel.work = 30
        viewModel.rest = 60
        viewModel.series = 5
        viewModel.rounds = 3
        viewModel.reset = 60

        // When
        let expectedTimeOverview = (((30 * 5) + (60 * (5 - 1)) + 60) * 3) - 60

        // Then
        expect(self.viewModel.timeOverview) == expectedTimeOverview
    }

    func testSelectedWorkoutManagerUpdates() {
        // Given
        let selectedWorkout = WorkOut()
        selectedWorkout.name = "Test Workout"
        selectedWorkout.work = 40
        selectedWorkout.rest = 45
        selectedWorkout.series = 3
        selectedWorkout.rounds = 2
        selectedWorkout.reset = 50
        viewModel.selectedWorkoutManager.selectedWorkout = selectedWorkout

        // Then
        expect(self.viewModel.name) == "Test Workout"
        expect(self.viewModel.work) == 40
        expect(self.viewModel.rest) == 45
        expect(self.viewModel.series) == 3
        expect(self.viewModel.rounds) == 2
        expect(self.viewModel.reset) == 50
    }

    func testScenePhaseUpdatesAppStorageManager() {
        // Given
        viewModel.selectedWorkout = WorkOut()
        viewModel.scenePhase = .active

        // When
        viewModel.scenePhase = .background

        // Then
        let storedWorkoutId = viewModel.appStorageManager.selectedWorkoutId
        expect(storedWorkoutId) == viewModel.selectedWorkout?._id.stringValue
    }

    func testScenePhaseNotUpdatesAppStorageManagerWhenNoSelectedWorkout() {
        // Given
        viewModel.appStorageManager.selectedWorkoutId = ""
        viewModel.selectedWorkout = nil
        viewModel.scenePhase = .active

        // When
        viewModel.scenePhase = .background

        // Then
        let storedWorkoutId = viewModel.appStorageManager.selectedWorkoutId
        expect(storedWorkoutId).to(beEmpty())
    }
}
