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
    var appStorageManaer: AppStorageManagerMock!

    override func setUp() {
        super.setUp()
        viewModel = WorkOutViewModel()
        appStorageManaer = AppStorageManagerMock()
        viewModel.appStorageManager = appStorageManaer
    }

    override func tearDown() {
        viewModel = nil
        appStorageManaer = nil
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
        let expectedTimeOverview = (((30 * 5) + (60 * 5) + 60) * 3) - 60

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

    func testStoreSelectedWorkoutId() {
        viewModel.selectedWorkout = WorkOut()
        viewModel.scenePhase = .inactive

        viewModel.storeSelectedWorkoutId(viewModel.scenePhase)

        expect(self.appStorageManaer.selectedWorkoutId)
            .to(equal(viewModel.selectedWorkout?._id.stringValue))
    }

    func testSetupRunViewModel() {
        let workout = WorkOut()

        viewModel.name = workout.name
        viewModel.work = workout.work
        viewModel.rest = workout.rest
        viewModel.series = workout.series
        viewModel.rounds = workout.rounds
        viewModel.reset = workout.reset

        viewModel.setupRunViewModel()

        expect(self.viewModel.isRunViewVisible).to(beTrue())
        expect(self.viewModel.runViewModel.workoutName).to(equal(workout.name))
        expect(self.viewModel.runViewModel.currentWorkout).notTo(beNil())
        expect(self.viewModel.runViewModel.currentWorkout!.work).to(equal(workout.work))
        expect(self.viewModel.runViewModel.currentWorkout!.rest).to(equal(workout.rest))
        expect(self.viewModel.runViewModel.currentWorkout!.series).to(equal(workout.series))
        expect(self.viewModel.runViewModel.currentWorkout!.rounds).to(equal(workout.rounds))
        expect(self.viewModel.runViewModel.currentWorkout!.reset).to(equal(workout.reset))
    }

    func testStoreWidgetData() {
        let workout = WorkOut()

        viewModel.selectedWorkout = workout
        viewModel.storeWidgetData()

        expect(self.appStorageManaer.loadFromDefaults(key: .workoutId)).notTo(beNil())
    }
}
