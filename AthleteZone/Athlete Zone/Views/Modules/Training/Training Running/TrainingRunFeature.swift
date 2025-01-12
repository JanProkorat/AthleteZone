//
//  TrainingRunFeature.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 01.03.2024.
//

import ComposableArchitecture
import Foundation

// swiftlint:disable closure_parameter_position
// swiftlint:disable pattern_matching_keywords
@Reducer
struct TrainingRunFeature {
    @ObservableState
    struct State {
        var selectedTab = 1
        var name: String
        var currentWorkout: WorkoutDto?
        var workouts: [WorkoutDto]
        var previousState: WorkFlowState = .ready
        var state: WorkFlowState = .ready
        var currentWorkflow: [WorkFlow] = []
        var currentActivity: WorkFlow?
        var currentFlowIndex = 0
        var currentWorkoutIndex = 0
        var timerTickInterval: TimeInterval = Constants.WorkoutTickInterval

        var isTimerActive = false
        var backgroundRunAllowed = false

        var isLastRunning: Bool {
            currentFlowIndex == currentWorkflow.count - 1 &&
                currentWorkoutIndex == workouts.count - 1
        }

        var isLastFlowRunning: Bool {
            currentFlowIndex == currentWorkflow.count - 1
        }

        var isFirstRunning: Bool {
            currentFlowIndex == 0 && currentWorkoutIndex == 0
        }

        @Presents var timerDestination: TimerDestination.State?
    }

    enum Action {
        case onAppear
        case setWorkflow(WorkoutDto)
        case setupNextActivity(Int)
        case stateChanged(WorkFlowState)
        case forwardTapped
        case backTapped
        case pauseTapped
        case quitTapped
        case playSound(Sound, Int)
        case timerDestination(PresentationAction<TimerDestination.Action>)
        case setupDestination
    }

    enum CancelID {
        case trainingRunTimer
    }

    @Dependency(\.appStorageManager) var appStorageManager
    @Dependency(\.soundManager) var soundManager
    @Dependency(\.dismiss) var dismiss
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.backgroundRunAllowed = appStorageManager.getRunInBackground()
                return .run { [workouts = state.workouts] send in
                    await send(.setupDestination)
                    await send(.setWorkflow(workouts.first!))
                    await send(.stateChanged(.preparation))
                }

            case .setWorkflow(let workout):
                state.currentWorkout = workout
                createFlow(workout: workout, state: &state)
                state.currentWorkoutIndex = state.workouts.firstIndex(of: workout)!
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

                    case .ready:
                        if previous == .running {
                            await send(.timerDestination(.presented(.timer(.stopTimer))))
                        }
                    }
                }

            case .forwardTapped:
                /// If last activity in workout is currently running, set up next in training
                if state.currentFlowIndex == state.currentWorkflow.count - 1 {
                    state.currentWorkoutIndex += 1
                    state.currentFlowIndex = 0
                    return .run { [currentWorkoutIndex = state.currentWorkoutIndex,
                                   workouts = state.workouts] send in
                            await send(.setWorkflow(workouts[currentWorkoutIndex]))
                            await send(.stateChanged(.ready))
                    }
                }
                state.currentFlowIndex += 1
                return .run { [
                    currentFlowIndex = state.currentFlowIndex,
                    state = state.state,
                    previousState = state.previousState
                ] send in
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
                                   workouts = state.workouts] send in
                            await send(.setWorkflow(workouts[currentWorkoutIndex]))
                    }
                }
                state.currentFlowIndex -= 1
                return .send(.setupNextActivity(state.currentFlowIndex))

            case .pauseTapped:
                switch state.state {
                case .finished:
                    state.currentFlowIndex = 0
                    state.currentWorkoutIndex = 0
                    return .run { [workouts = state.workouts] send in
                        await send(.setWorkflow(workouts.first!))
                        await send(.stateChanged(.preparation))
                    }

                case .paused:
                    return .send(.stateChanged(state.previousState))

                case .ready:
                    return .send(.stateChanged(.preparation))

                default:
                    return .send(.stateChanged(.paused))
                }

            case .quitTapped:
                return .run { send in
                    await send(.stateChanged(.quit))
                    await self.dismiss()
                }

            case .timerDestination(.presented(.timer(.delegate(.timerTick)))):
                if state.currentActivity != nil {
                    state.currentActivity!.interval -= state.timerTickInterval
                    if Constants.NotificationRange.contains(state.currentActivity!.interval) {
                        if appStorageManager.getSoundsEnabled() {
                            return .send(.playSound(.beep, Int(state.currentActivity!.interval - 1)))
                        }
                    }
                    if state.currentActivity!.interval.isTimeElapsedZero() {
                        if appStorageManager.getSoundsEnabled() {
                            return .send(.playSound(
                                state.isLastFlowRunning ? .fanfare : .gong,
                                Int(state.currentActivity!.interval)
                            ))
                        }
                    }
                    // Timer ticks to zero, handle next flow in row
                    if state.currentActivity!.interval < 0 {
                        // Last interval is running, finish workout
                        if state.isLastRunning {
                            return .send(.stateChanged(.finished))
                        }
                        // Move to next interval in row
                        return .send(.forwardTapped)
                    }
                }
                return .none

            case .playSound(let sound, let numOfLoops):
                if soundManager.isPlaying(), soundManager.selectedSound() == sound {
                    return .none
                }
                soundManager.playSound(sound, numOfLoops)
                return .none

            case .setupDestination:
                state.timerDestination = .timer(TimingFeature.State(timerTickInterval: state.timerTickInterval))
                return .none

            case .timerDestination:
                return .none
            }
        }
        .ifLet(\.$timerDestination, action: \.timerDestination)
    }

    private func createFlow(workout: WorkoutDto, state: inout TrainingRunFeature.State) {
        var flow: [WorkFlow] = []
        flow.append(WorkFlow(interval: 10, type: .preparation,
                             round: 1, serie: 1,
                             totalSeries: workout.series, totalRounds: workout.rounds))
        var serieCount = 1
        var interval = 0
        for round in 1 ... workout.rounds {
            for serie in 1 ... 2 * workout.series {
                interval = serie.isOdd() ? workout.work : workout.rest
                if interval != 0 {
                    flow.append(
                        WorkFlow(
                            interval: TimeInterval(interval - 1),
                            type: serie.isOdd() ? .work : .rest,
                            round: round,
                            serie: serieCount,
                            totalSeries: workout.series,
                            totalRounds: workout.rounds
                        )
                    )
                }
                if serie.isEven() {
                    serieCount += 1
                }
            }
            if round < workout.rounds {
                flow.append(
                    WorkFlow(
                        interval: TimeInterval(workout.reset),
                        type: .reset,
                        round: round,
                        serie: flow[flow.count - 1].serie,
                        totalSeries: workout.series,
                        totalRounds: workout.rounds
                    )
                )
                serieCount = 1
            }
        }

        state.currentWorkflow = flow
    }
}

extension TrainingRunFeature {
    @Reducer
    enum TimerDestination {
        case timer(TimingFeature)
    }
}
