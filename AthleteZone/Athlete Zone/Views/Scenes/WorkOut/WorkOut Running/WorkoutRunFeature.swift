//
//  WorkoutRunFeature.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 26.02.2024.
//

import ComposableArchitecture
import Foundation

// swiftlint:disable pattern_matching_keywords
@Reducer
struct WorkoutRunFeature {
    @ObservableState
    struct State {
        var name: String
        var work: Int
        var rest: Int
        var series: Int
        var rounds: Int
        var reset: Int
        var state: WorkFlowState = .ready
        var currentFlowIndex = 0
        var workflow: [WorkFlow] = []
        var currentActivity: WorkFlow?

        var isLastRunning: Bool {
            currentFlowIndex == workflow.count - 1 &&
                currentActivity != nil &&
                currentActivity!.type == .rest &&
                currentActivity!.lastRound &&
                currentActivity!.lastSerie
        }

        var isTimerActive = false
        var backgroundRunAllowed = false
    }

    enum Action {
        case onAppear
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

    enum WorkoutRunCancelID {
        case timer
    }

    @Dependency(\.soundManager) var soundManager
    @Dependency(\.appStorageManager) var appStorageManager
    @Dependency(\.continuousClock) var clock
    @Dependency(\.dismiss) var dismiss

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                createFlow(state: &state)
                return .run { send in
                    await send(.setupNextActivity(0))
                    await send(.stateChanged(.running))
                    await send(.setRunInBackground)
                }

            case .setupNextActivity(let index):
                state.currentActivity = state.workflow[index]
                return .none

            case .stateChanged(let newState):
                state.state = newState
                switch newState {
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
                    if state.isTimerActive {
                        state.isTimerActive = false
                        return .send(.stopTimer)
                    }
                    return .none

                default:
                    return .none
                }

            case .backTapped:
                state.currentFlowIndex -= 1
                return .send(.setupNextActivity(state.currentFlowIndex))

            case .forwardTapped:
                state.currentFlowIndex += 1
                return .send(.setupNextActivity(state.currentFlowIndex))

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
                            state.isLastRunning ? .fanfare : .gong,
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
                .cancellable(id: WorkoutRunCancelID.timer, cancelInFlight: true)

            case .playSound(let sound, let numOfLoops):
                if soundManager.isPlaying(), soundManager.selectedSound() == sound {
                    return .none
                }
                soundManager.playSound(sound, numOfLoops)
                return .none

            case .stopTimer:
                if soundManager.isPlaying() {
                    soundManager.stopSound()
                }
                return .cancel(id: WorkoutRunCancelID.timer)

            case .setRunInBackground:
                state.backgroundRunAllowed = appStorageManager.getRunInBackground()
                return .none
            }
        }
    }

    private func createFlow(state: inout WorkoutRunFeature.State) {
        var flow: [WorkFlow] = []
        flow.append(WorkFlow(interval: 10, type: .preparation,
                             round: 1, serie: 1,
                             totalSeries: state.series, totalRounds: state.rounds))
        var serieCount = 1
        var interval = 0
        for round in 1 ... state.rounds {
            for serie in 1 ... 2 * state.series {
                interval = serie.isOdd() ? state.work : state.rest
                if interval != 0 {
                    flow.append(
                        WorkFlow(
                            interval: TimeInterval(interval - 1),
                            type: serie.isOdd() ? .work : .rest,
                            round: round,
                            serie: serieCount,
                            totalSeries: state.series,
                            totalRounds: state.rounds
                        )
                    )
                }
                if serie.isEven() {
                    serieCount += 1
                }
            }
            if round < state.rounds {
                flow.append(
                    WorkFlow(
                        interval: TimeInterval(state.reset),
                        type: .reset,
                        round: round,
                        serie: flow[flow.count - 1].serie,
                        totalSeries: state.series,
                        totalRounds: state.rounds
                    )
                )
                serieCount = 1
            }
        }

        state.workflow = flow
    }
}
