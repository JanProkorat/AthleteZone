//
//  TrainingRunFeature.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 16.05.2024.
//

import ComposableArchitecture
import Foundation
import HealthKit
import SwiftUI

@Reducer
struct TrainingRunFeature {
    @ObservableState
    struct State: Equatable {
        var id = UUID()
        static func == (lhs: TrainingRunFeature.State, rhs: TrainingRunFeature.State) -> Bool {
            lhs.id == rhs.id
        }

        var selectedTab = 1
        var training: TrainingDto
        var currentWorkout: WorkoutDto?
        var previousState: WorkFlowState = .ready
        var state: WorkFlowState = .ready
        var currentWorkflow: [WorkFlow] = []
        var currentActivity: WorkFlow?
        var currentFlowIndex = 0
        var currentWorkoutIndex = 0
        var timeElapsed: TimeInterval = 0
        var timerTickInterval: TimeInterval = Constants.WorkoutTickInterval
        var activityResult: ActivityResultDto?

        var isLastRunning: Bool {
            currentFlowIndex == currentWorkflow.count - 1 &&
                currentWorkoutIndex == training.workouts.count - 1
        }

        var isLastFlowRunning: Bool {
            currentFlowIndex == currentWorkflow.count - 1
        }

        var isFirstRunning: Bool {
            currentFlowIndex == 0 && currentWorkoutIndex == 0
        }

        @Presents var healthDestination: HealthDestination.State?
        @Presents var timerDestination: TimerDestination.State?
    }

    enum Action {
        case selectedTabChanged(Int)
        case onAppear
        case setWorkflow(WorkoutDto)
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

    @Dependency(\.appStorageManager) var appStorageManager
    @Dependency(\.hapticManager) var hapticManager
    @Dependency(\.healthManager) var healthManager
    @Dependency(\.dismiss) var dismiss
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { [workouts = state.training.workouts] send in
                    await send(.setupDestinations)
                    await send(.setWorkflow(workouts.first!))
                    await send(.stateChanged(.preparation))
                }

            case .selectedTabChanged(let tabIndex):
                state.selectedTab = tabIndex
                return .none

            case .setWorkflow(let workout):
                state.currentWorkout = workout
                state.currentWorkflow = workout.toWorkflow()
                state.currentWorkoutIndex = state.training.workouts.firstIndex(of: workout)!
                state.currentFlowIndex = 0
                return .send(.setupNextActivity(0))

            case .setupNextActivity(let index):
                state.currentActivity = state.currentWorkflow[index]
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
                /// If last activity in workout is currently running, set up next in training
                if state.currentFlowIndex == state.currentWorkflow.count - 1 {
                    state.currentWorkoutIndex += 1
                    state.currentFlowIndex = 0
                    return .run { [currentWorkoutIndex = state.currentWorkoutIndex,
                                   workouts = state.training.workouts] send in
                            await send(.setWorkflow(workouts[currentWorkoutIndex]))
                            await send(.stateChanged(.paused))
                    }
                }
                state.currentFlowIndex += 1
                return .run { [currentFlowIndex = state.currentFlowIndex,
                               state = state.state,
                               previousState = state.previousState] send in
                        if state == .preparation || (state == .paused && previousState == .preparation) {
                            await send(.stateChanged(.running))
                        }
                        await send(.setupNextActivity(currentFlowIndex))
                }

            case .backTapped:
                if state.isFirstRunning {
                    return .none
                }

                if state.currentFlowIndex == 0 {
                    state.currentWorkoutIndex -= 1
                    return .run { [currentWorkoutIndex = state.currentWorkoutIndex,
                                   workouts = state.training.workouts] send in
                            await send(.setWorkflow(workouts[currentWorkoutIndex]))
                            await send(.stateChanged(.paused))
                    }
                }
                state.currentFlowIndex -= 1
                return .send(.setupNextActivity(state.currentFlowIndex))

            case .pauseTapped:
                return .run { [state = state.state, previousState = state.previousState] send in
                    let newState = state == .running || state == .preparation ? .paused :
                        state == .finished ? .preparation : previousState
                    await send(.stateChanged(newState), animation: .default)
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
                            return .run { [isLastRunning = state.isLastRunning] _ in
                                hapticManager.playHaptic(isLastRunning ? .success : .success)
                            }
                        }
                        return .none
                    }
                    // Timer ticks to zero, handle next flow in row
                    if state.currentActivity!.interval < 0 {
                        // Last interval is running, finish workout
                        if state.isLastRunning {
                            return .run { [workouts = state.training.workouts] send in
                                await send(.stateChanged(.finished))
                                await send(.setWorkflow(workouts.first!))
                            }
                        }
                        // Move to next interval in row
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
                    activityName: LocalizedStringKey(state.training.name)))
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

extension TrainingRunFeature {
    @Reducer
    enum HealthDestination {
        case health(HealthFeature)
    }

    @Reducer
    enum TimerDestination {
        case timer(TimingFeature)
    }
}
