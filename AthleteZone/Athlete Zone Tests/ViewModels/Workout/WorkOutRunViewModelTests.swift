//
//  WorkFlowViewModelTests.swift
//  Athlete Zone Tests
//
//  Created by Jan Prokorát on 17.03.2023.
//

@testable import Athlete_Zone
import Nimble
import XCTest

class WorkOutRunViewModelTests: XCTestCase {
    var viewModel: PhoneWorkOutRunViewModel!
    var workout: WorkOut!

    override func setUpWithError() throws {
        try super.setUpWithError()

        // Create a sample workout
        workout = WorkOut("Test Workout", 30, 10, 3, 2, 5)
        viewModel = PhoneWorkOutRunViewModel()
        viewModel.setupViewModel(workout: workout)
    }

    override func tearDownWithError() throws {
        viewModel = nil
        workout = nil
        try super.tearDownWithError()
    }

    func testInitialState() {
        // Assert initial state values
        expect(self.viewModel.workoutLibrary).toNot(beEmpty())
        expect(self.viewModel.currentWorkout).to(equal(workout))
        expect(self.viewModel.selectedFlow).toNot(beNil())
        expect(self.viewModel.selectedFlowIndex).to(equal(0))
        expect(self.viewModel.workoutName).to(equal("Test Workout"))
        expect(self.viewModel.state).to(equal(.ready))
        expect(self.viewModel.appStorageManager).to(beIdenticalTo(AppStorageManager.shared))
        expect(self.viewModel.isLastRunning).to(beFalse())
//        expect(self.viewModel.timer).to(beNil())
    }

//    func testIsLastRunning_FlowIsNotNil_LastRoundAndLastSerie_ShouldBeTrue() {
//        // Set up
//        viewModel.selectedFlow = WorkFlow(type: .work, interval: 30, lastRound: true, lastSerie: true)
//
//        // Assert that isLastRunning should be true
//        expect(self.viewModel.isLastRunning).to(beTrue())
//    }
//
//    func testIsLastRunning_FlowIsNotNil_OtherThanLastRoundOrLastSerie_ShouldBeFalse() {
//        // Set up
//        viewModel.selectedFlow = WorkFlow(type: .work, interval: 30, lastRound: false, lastSerie: true)
//
//        // Assert that isLastRunning should be false
//        expect(self.viewModel.isLastRunning).to(beFalse())
//    }

//    func testSetupNextWorkout_StateFinished_ShouldChangeCurrentWorkout() {
//        // Set up
//        let nextWorkout = WorkOut("Next Workout", 20, 5, 2, 3, 10)
//        viewModel.workoutLibrary = [workout, nextWorkout]
//        viewModel.state = .finished
//
//        // Call the method
//        viewModel.setupNextWorkout(.finished)
//
//        // Assert that the currentWorkout should change to the next one
//        expect(self.viewModel.currentWorkout).to(equal(nextWorkout))
//    }

    func testSetupNextWorkout_StateNotFinished_ShouldNotChangeCurrentWorkout() {
        // Set up
        let nextWorkout = WorkOut("Next Workout", 20, 5, 2, 3, 10)
        viewModel.workoutLibrary = [workout, nextWorkout]
        viewModel.state = .running

        // Call the method
        viewModel.setupNextWorkout(.running)

        // Assert that the currentWorkout should remain the same
        expect(self.viewModel.currentWorkout).to(equal(workout))
    }
}
