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
        var name: String
        var currentWorkout: WorkoutDto?
        var workouts: [WorkoutDto]
        var state: WorkFlowState = .ready
        var currentWorkflow: [WorkFlow] = []
        var currentActivity: WorkFlow?
        var currentFlowIndex = 0
        var currentWorkoutIndex = 0

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
        case timerTicked
        case startTimer
        case stopTimer
        case playSound(Sound, Int)
        case setRunInBackground
    }

    enum CancelID {
        case timer
    }

    @Dependency(\.appStorageManager) var appStorageManager
    @Dependency(\.soundManager) var soundManager
    @Dependency(\.continuousClock) var clock
    @Dependency(\.dismiss) var dismiss
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { [workouts = state.workouts] send in
                    await send(.setWorkflow(workouts.first!))
                    await send(.stateChanged(.running))
                    await send(.setRunInBackground)
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
                state.state = newState
                switch newState {
                case .ready:
                    if state.isTimerActive {
                        state.isTimerActive = false
                        return .send(.stopTimer)
                    }
                    return .none

                case .running:
                    state.isTimerActive = true
                    return .send(.startTimer)

                case .paused:
                    state.isTimerActive = false
                    return .send(.stopTimer)

                case .finished:
                    state.isTimerActive = false
                    return .send(.stopTimer)

                case .quit:
                    state.isTimerActive = false
                    return .send(.stopTimer)
                }

            case .forwardTapped:
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
                return .send(.setupNextActivity(state.currentFlowIndex))

            case .backTapped:
                if !state.isFirstRunning, state.currentFlowIndex == 0 {
                    state.currentWorkoutIndex -= 1
                    state.currentFlowIndex = 0
                    return .run { [currentWorkoutIndex = state.currentWorkoutIndex,
                                   workouts = state.workouts] send in
                            await send(.setWorkflow(workouts[currentWorkoutIndex]))
                            await send(.stateChanged(.ready))
                    }
                }
                return .none

            case .pauseTapped:
                return .send(.stateChanged(state.state == .running ? .paused : .running))

            case .quitTapped:
                return .run { send in
                    await send(.stateChanged(.quit))
                    await self.dismiss()
                }

            case .timerTicked:
                if state.currentActivity != nil {
                    state.currentActivity!.interval -= 1
                    if state.currentActivity!.interval <= 3, state.currentActivity!.interval > 0 {
                        return .send(.playSound(.beep, Int(state.currentActivity!.interval - 1)))
                    }
                    if state.currentActivity!.interval == 0 {
                        return .send(.playSound(
                            state.isLastFlowRunning ? .fanfare : .gong,
                            Int(state.currentActivity!.interval)
                        ))
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

            case .startTimer:
                return .run { [isTimerActive = state.isTimerActive] send in
                    guard isTimerActive else { return }
                    for await _ in self.clock.timer(interval: .seconds(1)) {
                        await send(.timerTicked, animation: .interpolatingSpring(stiffness: 3000, damping: 40))
                    }
                }
                .cancellable(id: CancelID.timer, cancelInFlight: true)

            case .stopTimer:
                if soundManager.isSoundPlaying, soundManager.selectedSound != .fanfare {
                    soundManager.stop()
                }
                return .cancel(id: CancelID.timer)

            case .setRunInBackground:
                state.backgroundRunAllowed = appStorageManager.getRunInBackground()
                return .none

            case .playSound(let sound, let numOfLoops):
                if soundManager.isSoundPlaying, soundManager.selectedSound == sound {
                    return .none
                }
                soundManager.playSound(sound: sound, numOfLoops: numOfLoops)
                return .none
            }
        }
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
