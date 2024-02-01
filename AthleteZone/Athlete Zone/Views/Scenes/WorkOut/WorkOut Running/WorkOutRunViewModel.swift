//
//  WorkFlowViewModel.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 15.11.2022.
//

import Combine
import Foundation
import SwiftUI

class WorkOutRunViewModel<T: WorkOutProtocol>: ObservableObject, Identifiable {
    @Published var workoutLibrary: [T] = []

    @Published var currentWorkout: T?
    @Published var selectedFlow: WorkFlow?
    @Published var nextWorkout: T?

    @Published var workoutName = ""
    @Published var selectedFlowIndex = 0
    @Published var state: WorkFlowState = .ready

    var isLastRunning: Bool {
        selectedFlow != nil &&
            selectedFlow!.type == .work &&
            selectedFlow!.lastRound &&
            selectedFlow!.lastSerie
    }

    var isFirstRunning: Bool {
        selectedFlowIndex == 0
    }

    var timerManager: any TimerProtocol
    var stateManager: any StateProtocol

    var cancellables = Set<AnyCancellable>()

    init() {
        timerManager = TimerManager.shared
        stateManager = StateManager.shared

        stateManager.statePublisher
            .sink { newState in
                DispatchQueue.main.async {
                    self.state = newState
                }
            }
            .store(in: &cancellables)

        $state
            .scan((stateManager.state, stateManager.state)) { previous, current -> (WorkFlowState, WorkFlowState) in
                (previous.1, current)
            }
            .receive(on: DispatchQueue.main)
            .sink { self.updateTimerOnStateChange($0.0, $0.1) }
            .store(in: &cancellables)

        $selectedFlowIndex
            .sink { self.updateFlowOnIndexChange($0) }
            .store(in: &cancellables)

        stateManager.statePublisher
            .sink { self.setupNextWorkout($0) }
            .store(in: &cancellables)

        $currentWorkout
            .sink { self.selectedFlow = $0?.workFlow[0] }
            .store(in: &cancellables)
    }

    func setupViewModel(workout: T) {
        currentWorkout = workout
        workoutName = workout.name
        workoutLibrary = [workout]
        stateManager.setState(.ready)
    }

    func setupViewModel(workouts: [T]) {
        workoutLibrary = workouts
        currentWorkout = workouts.first
        workoutName = workouts.first?.name ?? ""
        stateManager.setState(.ready)
    }

    func setState(_ state: WorkFlowState) {
        stateManager.setState(state)
    }

    func setupNextWorkout(_ state: WorkFlowState) {
        if state == .finished {
            let currentIndex = workoutLibrary.firstIndex(of: currentWorkout!)!
            if currentIndex < workoutLibrary.endIndex - 1 {
                currentWorkout = workoutLibrary[currentIndex + 1]
            } else {
                currentWorkout = workoutLibrary.first
            }
            workoutName = currentWorkout!.name
        }
    }

    func updateInterval() {
        if selectedFlow != nil {
            if selectedFlow!.interval > 0 {
                selectedFlow!.interval -= 1
            } else {
                selectedFlowIndex += 1
            }
        }
    }

    func updateFlowOnIndexChange(_ newFlowIndex: Int) {
        if let workout = currentWorkout {
            if newFlowIndex < workout.workFlow.count {
                selectedFlow = workout.workFlow[newFlowIndex]
            } else if isLastRunning {
                setState(.finished)
            }
        }
    }

    func updateTimerOnStateChange(_ previous: WorkFlowState, _ newState: WorkFlowState) {}
}
