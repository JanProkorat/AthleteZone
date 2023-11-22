//
//  PhoneWorkOutRunViewModelTests.swift
//  Athlete Zone Tests
//
//  Created by Jan Prokorát on 21.11.2023.
//

@testable import Athlete_Zone
import Nimble
import XCTest

class PhoneWorkOutRunViewModelTests: XCTestCase {
    var viewModel: PhoneWorkOutRunViewModel!
    var workout: WorkOut!
    var timer: TimerManagerMock!
    var soundmanager: SoundManagerMock!

    override func setUpWithError() throws {
        try super.setUpWithError()

        // Create a sample workout
        workout = WorkOut("Test Workout", 30, 10, 3, 2, 5)
        viewModel = PhoneWorkOutRunViewModel()
        viewModel.setupViewModel(workout: workout)

        timer = TimerManagerMock()
        viewModel.timerManager = timer
        viewModel.liveActivityManager = LiveActivityManagerMock()

        soundmanager = SoundManagerMock()
        viewModel.soundManager = soundmanager
    }

    override func tearDownWithError() throws {
        viewModel = nil
        workout = nil
        timer = nil
        try super.tearDownWithError()
    }

    func testUpdateTimerOnStateChange_newStateEqualAsOld() {
        // Set up
        let state = viewModel.state

        // Action
        viewModel.updateTimerOnStateChange(state, state)

        // Assert
        expect(self.viewModel.state).to(equal(state))
    }

    func testUpdateTimerOnStateChange_newState_paused() {
        // Set up
        timer.startTimer()

        // Action
        viewModel.updateTimerOnStateChange(.ready, .paused)

        // Assert
        expect(self.viewModel.timerManager.timeElapsed).to(equal(0))
    }

    func testUpdateTimerOnStateChange_newState_finished() {
        // Set up
        timer.startTimer()

        // Action
        viewModel.updateTimerOnStateChange(.ready, .finished)

        // Assert
        expect(self.viewModel.timerManager.timeElapsed).to(equal(0))
        expect(self.viewModel.selectedFlowIndex).to(equal(0))
    }

    func testUpdateTimerOnStateChange_newState_running() {
        // Action
        viewModel.updateTimerOnStateChange(.ready, .running)

        // Assert
        expect(self.viewModel.timerManager.timeElapsed).to(equal(1))
    }

    func testUpdateTimerOnStateChange_newState_quit() {
        // Action
        viewModel.updateTimerOnStateChange(.ready, .quit)

        // Assert
        expect(self.viewModel.timerManager.timeElapsed).to(equal(0))
        expect(self.viewModel.selectedFlowIndex).to(equal(0))
        expect(self.viewModel.currentWorkout).to(beNil())
        expect(self.viewModel.nextWorkout).to(beNil())
    }

    func testPlaySound_beep() {
        // Set up
        viewModel.selectedFlow?.interval = 3
        viewModel.setState(.running)

        viewModel.playSound(viewModel.selectedFlow)

        expect(self.viewModel.soundManager.isSoundPlaying).to(beTrue())
        expect(self.viewModel.soundManager.selectedSound).to(equal(.beep))
    }

    func testPlaySound_gong() {
        // Set up
        viewModel.selectedFlow?.interval = 0
        viewModel.setState(.running)

        viewModel.playSound(viewModel.selectedFlow)

        expect(self.viewModel.soundManager.isSoundPlaying).to(beTrue())
        expect(self.viewModel.soundManager.selectedSound).to(equal(.gong))
    }

    func testPlaySound_fanfare() {
        // Set up
        viewModel.selectedFlow = viewModel.currentWorkout?.workFlow.last
        viewModel.selectedFlow?.interval = 0
        viewModel.setState(.running)

        viewModel.playSound(viewModel.selectedFlow)

        expect(self.viewModel.soundManager.isSoundPlaying).to(beTrue())
        expect(self.viewModel.soundManager.selectedSound).to(equal(.fanfare))
    }
}
