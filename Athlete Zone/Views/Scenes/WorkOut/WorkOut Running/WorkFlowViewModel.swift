//
//  WorkFlowViewModel.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 15.11.2022.
//

import Combine
import Foundation
import SwiftUI

class WorkFlowViewModel: ObservableObject {
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

    var timer: Timer?
    private var soundManager: SoundProtocol?
    private var hapticManager: HapticProtocol?

    private var cancellables = Set<AnyCancellable>()

    init(workout: WorkOut) {
        currentWorkout = workout
        workoutName = workout.name
        workoutLibrary = [workout]

        initViewModel()
    }

    init(workouts: [WorkOut]) {
        workoutLibrary = workouts
        currentWorkout = workouts.first
        workoutName = workouts.first!.name

        initViewModel()
    }

    private func initViewModel() {
        soundManager = SoundManager()

        #if os(watchOS)
        hapticManager = HapticManager()
        #endif

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

        $selectedFlow
            .sink { newValue in
                if self.appStorageManager.hapticsEnabled {
                    self.playHaptic(newValue)
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
        }
    }
}

// MARK: Timer extension

extension WorkFlowViewModel {
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            if self?.selectedFlow != nil {
                self?.updateInterval()
            }
        }
    }

    func stopTimer() {
        timer?.invalidate()
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

    func updateTimerOnStateChange(_ previous: WorkFlowState, _ newState: WorkFlowState) {
        if newState != previous {
            switch newState {
            case .paused:
                stopTimer()

            case .finished:
                stopTimer()
                selectedFlowIndex = 0
                if let next = nextWorkout {
                    currentWorkout = next
                    nextWorkout = nil
                }

            case .running:
                startTimer()

            default:
                break
            }
        }
    }
}

// MARK: Sound extension

extension WorkFlowViewModel {
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

// MARK: Haptic extensio

extension WorkFlowViewModel {
    func playHaptic(_ worflow: WorkFlow?) {
        if state == .running {
            if let flow = worflow {
                if flow.interval > 0 {
                    if flow.interval <= 3 {
                        hapticManager?.playHaptic()
                    }
                } else {
                    hapticManager?.playFinishHaptic()
                }
            }
        }
    }
}
