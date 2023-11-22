//
//  WorkOutRunViewModel.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 27.09.2023.
//

import Combine
import HealthKit

class WatchWorkOutRunViewModel: WorkOutRunViewModel<WorkOutDto> {
    private var healthManager = HealthWorkouthManager()
    private var hapticManager = HapticManager()
    private var soundManager: SoundProtocol?

    @Published var timeElapsed: String = "00:00:00"
    @Published var heartRate: Double = 0
    @Published var activeEnergy: Double = 0
    @Published var baseEnergy: Double = 0

    override init() {
        super.init()

        $selectedFlow
            .sink { newValue in
                if self.appStorageManager.hapticsEnabled {
                    self.playHaptic(newValue)
                }
            }
            .store(in: &cancellables)

        timerManager.timeElapsedPublisher
            .sink { elapsed in
                if self.selectedFlow != nil {
                    self.updateInterval()
                }
                self.timeElapsed = self.formatElapsedTime(elapsed)
            }
            .store(in: &cancellables)

        healthManager.$activeEnergy
            .sink { self.activeEnergy = $0 }
            .store(in: &cancellables)

        healthManager.$baseEnergy
            .sink { self.baseEnergy = $0 }
            .store(in: &cancellables)

        healthManager.$averageHeartRate
            .sink { self.heartRate = $0 }
            .store(in: &cancellables)
    }

    override func updateTimerOnStateChange(_ previous: WorkFlowState, _ newState: WorkFlowState) {
        if newState != previous {
            switch newState {
            case .paused:
                timerManager.pauseTimer()
                togglePauseHealthWorkout()

            case .finished:
                timerManager.pauseTimer()
                selectedFlow = nil
                selectedFlowIndex = 0
                if let next = nextWorkout {
                    currentWorkout = next
                    nextWorkout = nil
                } else {
                    endHealthWorkout()
                }

            case .running:
                timerManager.startTimer()
                startHealthWorkout()

            case .quit:
                timerManager.stopTimer()
                selectedFlow = nil
                selectedFlowIndex = 0
                currentWorkout = nil
                nextWorkout = nil

            default:
                break
            }
        }
    }
}

// MARK: Health extension

extension WatchWorkOutRunViewModel {
    func startHealthWorkout() {
        let status = healthManager.checkAuthorizationStatus()
        if status != .sharingAuthorized {
            return
        }

        if healthManager.paused {
            healthManager.resume()
        } else {
            healthManager.startWorkout(workoutType: .traditionalStrengthTraining, workoutName: workoutName)
        }
    }

    func endHealthWorkout() {
        if healthManager.running {
            healthManager.endWorkout()
        }
    }

    func togglePauseHealthWorkout() {
        healthManager.togglePuase()
    }
}

// MARK: Haptic extension

extension WatchWorkOutRunViewModel {
    func playHaptic(_ worflow: WorkFlow?) {
        if state == .running {
            if let flow = worflow {
                if flow.interval > 0 {
                    if flow.interval <= 3 {
                        hapticManager.playHaptic()
                    }
                } else {
                    hapticManager.playFinishHaptic()
                }
            }
        }
    }
}

extension WatchWorkOutRunViewModel {
    func formatElapsedTime(_ timeInterval: TimeInterval?) -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = [.pad]

        return formatter.string(from: timeInterval ?? 0) ?? ""
    }
}
