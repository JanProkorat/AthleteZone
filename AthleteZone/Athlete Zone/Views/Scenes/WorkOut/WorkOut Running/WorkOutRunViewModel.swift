//
//  WorkFlowViewModel.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 15.11.2022.
//

import Combine
import Foundation
import SwiftUI

class WorkOutRunViewModel: ObservableObject, Identifiable {
    @Published var workoutLibrary: [WorkOut] = []

    @Published var currentWorkout: WorkOut?
    @Published var selectedFlow: WorkFlow?
    @Published var nextWorkout: WorkOut?

    @Published var workoutName = ""
    @Published var selectedFlowIndex = 0

    @Published var state: WorkFlowState = .ready
    @Published var appStorageManager = AppStorageManager.shared

    var isLastRunning: Bool {
        selectedFlow != nil &&
            selectedFlow!.type == .work &&
            selectedFlow!.lastRound &&
            selectedFlow!.lastSerie
    }

    var isFirstRunning: Bool {
        selectedFlowIndex == 0
    }

    private var soundManager: SoundProtocol?
    var timerManager = TimerManager.shared

    var cancellables = Set<AnyCancellable>()

    init() {
        soundManager = SoundManager()

        $state
            .scan((state, state)) { previous, current -> (WorkFlowState, WorkFlowState) in
                (previous.1, current)
            }
            .receive(on: DispatchQueue.main)
            .sink { self.updateTimerOnStateChange($0.0, $0.1) }
            .store(in: &cancellables)

        $selectedFlowIndex
            .sink { self.updateFlowOnIndexChange($0) }
            .store(in: &cancellables)

        $selectedFlow
            .sink { newValue in
                if self.appStorageManager.soundsEnabled {
                    self.playSound(newValue)
                }
            }
            .store(in: &cancellables)

        $state
            .sink { self.setupNextWorkout($0) }
            .store(in: &cancellables)

        $currentWorkout
            .sink { self.selectedFlow = $0?.workFlow[0] }
            .store(in: &cancellables)
    }

    func setupViewModel(workout: WorkOut) {
        currentWorkout = workout
        workoutName = workout.name
        workoutLibrary = [workout]
    }

    func setupViewModel(workouts: [WorkOut]) {
        workoutLibrary = workouts
        currentWorkout = workouts.first
        workoutName = workouts.first!.name
    }

    func setState(_ state: WorkFlowState) {
        self.state = state
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

// MARK: Sound extension

extension WorkOutRunViewModel {
    func playSound(_ worflow: WorkFlow?) {
        if state == .running {
            if let flow = worflow {
                if flow.interval > 0 {
                    if flow.interval <= 3 {
                        soundManager?.playSound(sound: .beep)
                    }
                } else {
                    if isLastRunning {
                        soundManager?.playSound(sound: .fanfare)
                    } else {
                        soundManager?.playSound(sound: .gong)
                    }
                }
            }
        }
    }

    func stopSound() {
        soundManager?.stop()
    }
}
