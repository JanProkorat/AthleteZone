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
        var activityName: String
        var state: WorkFlowState = .ready
        var previousState: WorkFlowState = .ready
    }

    enum Action {
        case startTimer
        case stopTimer
        case timerTicked
        case stateChanged(WorkFlowState, WorkFlowState)
        case startWorkout
        case endWorkout
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

            case .stateChanged(let old, let new):
                state.previousState = old
                state.state = new
                switch new {
                case .running:
                    state.isTimerActive = true
                    return .run { send in
                        await send(.startTimer)
                        await send(.startWorkout)
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
                    state.isTimerActive = false
                    return .run { send in
                        await send(.stopTimer)
                        await send(.endWorkout)
                    }

                default:
                    return .none
                }

            case .startWorkout:
                return .run { [activityName = state.activityName] _ in
                    if healthManager.isPaused() {
                        healthManager.togglePuase()
                    } else if !healthManager.isRunning() {
                        await healthManager.startWorkout(.other, activityName)
                    }
                }

            case .endWorkout:
                if healthManager.isRunning() {
                    healthManager.endWorkout()
                }
                switch state.previousState {
                case .preparation:
                    return .send(.delegate(.quitInPreparation))

                default:
                    return .send(.delegate(.trackingEnded(ActivityResultDto(
                        duration: healthManager.getWorkoutDuration(),
                        heartRate: healthManager.getAverageHeartRate(),
                        activeEnergy: healthManager.getActiveEnergy(),
                        totalEnergy: healthManager.getCalmEnergy()
                    ))))
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
}
