//
//  HealthFeature.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 17.07.2024.
//

import Combine
import ComposableArchitecture
import Foundation
import HealthKit
import SwiftUI

@Reducer
struct HealthFeature {
    @ObservableState
    struct State: Equatable {
        var hkAccessStatus: HKAuthorizationStatus = .notDetermined
        var timeElapsed: TimeInterval = 0
        var isTimerActive = false
        var activityName: LocalizedStringKey
        var state: WorkFlowState = .ready
    }

    enum Action {
        case startTimer
        case stopTimer
        case timerTicked
        case stateChanged(WorkFlowState, WorkFlowState)
        case delegate(Delegate)

        enum Delegate {
            case trackingEnded(ActivityResultDto)
            case quitInPreparation
        }
    }

    enum CancelID {
        case healthViewTimer
    }

    @Dependency(\.healthManager) var healthManager
    @Dependency(\.continuousClock) var clock
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .startTimer:
                return .run { [isTimerActive = state.isTimerActive] send in
                    guard isTimerActive else { return }
                    for await _ in self.clock.timer(interval: .seconds(0.01)) {
                        await send(.timerTicked)
                    }
                }
                .cancellable(id: CancelID.healthViewTimer, cancelInFlight: true)

            case .stopTimer:
                return .cancel(id: CancelID.healthViewTimer)

            case .timerTicked:
                state.timeElapsed += 0.01
                return .none

            case .stateChanged(let previous, let new):
                state.state = new
                switch new {
                case .running:
//                    startHealthWorkout(hkAccessStatus: state.hkAccessStatus, name: state.activityName)
                    state.isTimerActive = true
                    return .run { send in
                        await healthManager.startWorkout(.other, "test")
                        await send(.startTimer)
                    }

                case .paused:
                    togglePuase(hkAccessStatus: state.hkAccessStatus)
                    state.isTimerActive = false
                    return .send(.stopTimer)

                case .finished:
                    togglePuase(hkAccessStatus: state.hkAccessStatus)
                    state.isTimerActive = false
                    return .send(.stopTimer)

                case .quit:
                    endWorkout(hkAccessStatus: state.hkAccessStatus)
                    state.isTimerActive = false
                    return .run { send in
                        await send(.stopTimer)
                        if previous == .preparation {
                            await send(.delegate(.quitInPreparation))
                        } else {
                            await send(.delegate(.trackingEnded(ActivityResultDto(
                                duration: healthManager.getWorkoutDuration(),
                                heartRate: healthManager.getAverageHeartRate(),
                                activeEnergy: healthManager.getActiveEnergy(),
                                totalEnergy: healthManager.getTotalEnergy()
                            ))))
                        }
                    }

                default:
                    return .none
                }

            case .delegate:
                return .none
            }
        }
    }

    private func togglePuase(hkAccessStatus: HKAuthorizationStatus) {
        if hkAccessStatus != .sharingAuthorized {
            return
        }

        healthManager.togglePuase()
    }

    private func startHealthWorkout(hkAccessStatus: HKAuthorizationStatus, name: LocalizedStringKey) {
        if hkAccessStatus != .sharingAuthorized {
            return
        }

        if healthManager.isPaused() {
            healthManager.togglePuase()
        } else {
//            healthManager.startWorkout(.traditionalStrengthTraining, "test")
        }
    }

    private func endWorkout(hkAccessStatus: HKAuthorizationStatus) {
        if hkAccessStatus != .sharingAuthorized {
            return
        }

        healthManager.endWorkout()
    }
}
