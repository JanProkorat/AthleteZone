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
    }

    func testIsLastRunning_FlowIsNotNil_LastRoundAndLastSerie_ShouldBeTrue() {
        // Set up
        viewModel.selectedFlow = workout.workFlow.last

        // Assert that isLastRunning should be true
        expect(self.viewModel.isLastRunning).to(beTrue())
    }

    func testIsLastRunning_FlowIsNotNil_OtherThanLastRoundOrLastSerie_ShouldBeFalse() {
        // Set up
        viewModel.selectedFlow = workout.workFlow.first

        // Assert that isLastRunning should be false
        expect(self.viewModel.isLastRunning).to(beFalse())
    }

    func testSetupViewModel_singleItem() {
        // Set up
        let newWorkout = WorkOut("Next Workout", 20, 5, 2, 3, 10)
        viewModel.setupViewModel(workout: newWorkout)

        // Assert
        expect(self.viewModel.currentWorkout).to(equal(newWorkout))
        expect(self.viewModel.workoutName).to(equal(newWorkout.name))
        expect(self.viewModel.workoutLibrary.first).to(equal(newWorkout))
        expect(self.viewModel.state).to(equal(.ready))
    }

    func testSetupViewModel_smultipleItems() {
        // Set up
        let newWorkout = WorkOut("Next Workout", 20, 5, 2, 3, 10)
        viewModel.setupViewModel(workouts: [newWorkout])

        // Assert
        expect(self.viewModel.currentWorkout).to(equal(newWorkout))
        expect(self.viewModel.workoutName).to(equal(newWorkout.name))
        expect(self.viewModel.workoutLibrary.first).to(equal(newWorkout))
        expect(self.viewModel.state).to(equal(.ready))
    }

    func testSetupNextWorkout_StateFinished_ShouldChangeCurrentWorkout() {
        // Set up
        let nextWorkout = WorkOut("Next Workout", 20, 5, 2, 3, 10)
        viewModel.setupViewModel(workouts: [workout, nextWorkout])

        // Call the method
        viewModel.setState(.finished)

        // Assert that the currentWorkout should change to the next one
        expect(self.viewModel.currentWorkout).to(equal(nextWorkout))
    }

    func testSetupNextWorkout_StateNotFinished_ShouldNotChangeCurrentWorkout() {
        // Set up
        let nextWorkout = WorkOut("Next Workout", 20, 5, 2, 3, 10)
        viewModel.setupViewModel(workouts: [workout, nextWorkout])

        // Call the method
        viewModel.setState(.paused)

        // Assert that the currentWorkout should remain the same
        expect(self.viewModel.currentWorkout).to(equal(workout))
    }

    func testUpdateInterval_updateInterval() {
        // Set up
        let interval = viewModel.selectedFlow!.interval

        // Call the method
        viewModel.updateInterval()

        // Assert
        expect(self.viewModel.selectedFlow?.interval).to(equal(interval - 1))
    }

    func testUpdateInterval_updateIndex() {
        // Set up
        let index = viewModel.selectedFlowIndex
        let nextFlow = viewModel.currentWorkout?.workFlow[1]
        viewModel.selectedFlow!.interval = 0

        // Call the method
        viewModel.updateInterval()

        // Assert
        expect(self.viewModel.selectedFlowIndex).to(equal(index + 1))
        expect(self.viewModel.selectedFlow).to(equal(nextFlow))
    }

    func testUpdateFlowOnIndexChange_setupNextWorkout() {
        // Set up
        let nextFlow = viewModel.currentWorkout?.workFlow[1]

        // Call the method
        viewModel.updateFlowOnIndexChange(1)

        // Assert
        expect(self.viewModel.selectedFlow).to(equal(nextFlow))
    }

    func testUpdateFlowOnIndexChange_lastFlow_endWorkout() {
        // Set up
        viewModel.selectedFlow = workout.workFlow.last

        // Call the method
        viewModel.updateFlowOnIndexChange(viewModel.currentWorkout!.workFlow.count)

        // Assert
        expect(self.viewModel.state).to(equal(.finished))

    }
}
