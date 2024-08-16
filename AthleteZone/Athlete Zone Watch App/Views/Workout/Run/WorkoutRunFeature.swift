//
//  WorkoutRunFeature.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 16.05.2024.
//

import ComposableArchitecture
import Foundation
import HealthKit
import SwiftUI

@Reducer
struct WorkoutRunFeature {
    @ObservableState
    struct State: Equatable {
        var id = UUID()
        static func == (lhs: WorkoutRunFeature.State, rhs: WorkoutRunFeature.State) -> Bool {
            lhs.id == rhs.id
        }

        var workout: WorkoutDto
        var selectedTab = 0
        var previousState: WorkFlowState = .ready
        var state: WorkFlowState = .ready
        var currentFlowIndex = 0
        var workflow: [WorkFlow] = []
        var currentActivity: WorkFlow?
        var timerTickInterval: TimeInterval = Constants.WorkoutTickInterval
        var activityResult: ActivityResultDto?

        var isLastRunning: Bool {
            currentFlowIndex == workflow.count - 1 &&
                currentActivity != nil &&
                currentActivity!.type == .rest &&
                currentActivity!.lastRound &&
                currentActivity!.lastSerie
        }

        var isFirstRunning: Bool {
            currentFlowIndex == 0
        }

        @Presents var healthDestination: HealthDestination.State?
        @Presents var timerDestination: TimerDestination.State?
    }

    enum Action {
        case selectedTabChanged(Int)
        case onAppear
        case setupNextActivity(Int)
        case stateChanged(WorkFlowState)
        case forwardTapped
        case backTapped
        case pauseTapped
        case quitTapped
        case setupDestinations
        case healthDestination(PresentationAction<HealthDestination.Action>)
        case timerDestination(PresentationAction<TimerDestination.Action>)
        case activityResultChanged(ActivityResultDto?)
        case dismiss
    }

    @Dependency(\.hapticManager) var hapticManager
    @Dependency(\.appStorageManager) var appStorageManager
    @Dependency(\.healthManager) var healthManager
    @Dependency(\.dismiss) var dismiss
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.workflow = state.workout.toWorkflow()
                return .run { send in
                    await send(.setupDestinations)
                    await send(.setupNextActivity(0))
                    await send(.stateChanged(.preparation))
                }

            case .selectedTabChanged(let tabIndex):
                state.selectedTab = tabIndex
                return .none

            case .setupNextActivity(let index):
                state.currentActivity = state.workflow[index]
                return .none

            case .stateChanged(let newState):
                state.previousState = state.state
                state.state = newState
                return .run { [previous = state.previousState, new = state.state] send in
                    switch new {
                    case .preparation, .running:
                        await send(.timerDestination(.presented(.timer(.startTimer))))

                    case .paused, .finished, .quit:
                        await send(.timerDestination(.presented(.timer(.stopTimer))))

                    default:
                        break
                    }

                    await send(.healthDestination(.presented(.health(.stateChanged(previous, new)))))
                }

            case .forwardTapped:
                state.currentFlowIndex += 1
                return .run { [index = state.currentFlowIndex, state = state.state, previousState = state.previousState] send in
                    if state == .preparation || (state == .paused && previousState == .preparation) {
                        await send(.stateChanged(.running))
                    }
                    await send(.setupNextActivity(index))
                }

            case .backTapped:
                state.currentFlowIndex -= 1
                return .send(.setupNextActivity(state.currentFlowIndex))

            case .pauseTapped:
                switch state.state {
                case .finished:
                    state.currentFlowIndex = 0
                    return .run { send in
                        await send(.setupNextActivity(0))
                        await send(.stateChanged(.preparation))
                    }

                case .paused:
                    return .send(.stateChanged(.running))

                default:
                    return .send(.stateChanged(.paused))
                }

            case .quitTapped:
                return .send(.stateChanged(.quit))

            case .timerDestination(.presented(.timer(.delegate(.timerTick)))):
                if state.currentActivity != nil {
                    state.currentActivity!.interval -= state.timerTickInterval
                    if Constants.NotificationRange.contains(state.currentActivity!.interval) {
                        if appStorageManager.getHapticsEnabled() {
                            return .run { _ in
                                hapticManager.playHaptic(.start)
                            }
                        }
                        return .none
                    }
                    if state.currentActivity!.interval.isTimeElapsedZero() {
                        if appStorageManager.getHapticsEnabled() {
                            return .run { [isLastRunning = state.isLastRunning] send in
                                hapticManager.playHaptic(isLastRunning ? .success : .success)
                                if isLastRunning {
                                    await send(.stateChanged(.finished))
                                }
                            }
                        }
                        return .none
                    }
                    if state.currentActivity!.interval < 0 {
                        return .send(.forwardTapped)
                    }
                }
                return .none

            case .healthDestination(.presented(.health(.delegate(.trackingEnded(let result))))):
                return .send(.activityResultChanged(result))

            case .healthDestination(.presented(.health(.delegate(.quitInPreparation)))):
                return .send(.dismiss)

            case .healthDestination:
                return .none

            case .setupDestinations:
                let accessStatus = healthManager.getAuthorizationStatus()
                state.healthDestination = .health(HealthFeature.State(
                    hkAccessStatus: accessStatus,
                    activityName: state.workout.name))
                state.timerDestination = .timer(TimingFeature.State(timerTickInterval: state.timerTickInterval))
                return .none

            case .timerDestination:
                return .none

            case .activityResultChanged(let result):
                state.activityResult = result
                if result == nil {
                    healthManager.resetWorkout()
                    return .send(.dismiss)
                }
                return .none

            case .dismiss:
                return .run { _ in
                    await self.dismiss()
                }
            }
        }
        .ifLet(\.$healthDestination, action: \.healthDestination)
        .ifLet(\.$timerDestination, action: \.timerDestination)
    }
}

extension WorkoutRunFeature {
    @Reducer
    enum HealthDestination {
        case health(HealthFeature)
    }

    @Reducer
    enum TimerDestination {
        case timer(TimingFeature)
    }
}
