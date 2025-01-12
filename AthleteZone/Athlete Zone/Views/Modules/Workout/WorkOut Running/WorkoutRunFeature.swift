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
        var previousState: WorkFlowState = .ready
        var state: WorkFlowState = .ready
        var currentFlowIndex = 0
        var workflow: [WorkFlow] = []
        var currentActivity: WorkFlow?
        var activity: NSObjectProtocol?
        var timerTickInterval: TimeInterval = Constants.WorkoutTickInterval

        var isLastRunning: Bool {
            currentFlowIndex == workflow.count - 1 &&
                currentActivity != nil &&
                currentActivity!.type == .rest &&
                currentActivity!.lastRound &&
                currentActivity!.lastSerie
        }

        var isTimerActive = false
        var backgroundRunAllowed = false

        @Presents var timerDestination: TimerDestination.State?
    }

    enum Action {
        case onAppear
        case setupNextActivity(Int)
        case stateChanged(WorkFlowState)
        case forwardTapped
        case backTapped
        case pauseTapped
        case quitTapped
        case playSound(Sound, Int)
        case timerDestination(PresentationAction<TimerDestination.Action>)
        case setupTimerDestination
    }

    enum WorkoutRunCancelID {
        case workoutRunTimer
    }

    @Dependency(\.appStorageManager) var appStorageManager
    @Dependency(\.soundManager) var soundManager
    @Dependency(\.continuousClock) var clock
    @Dependency(\.dismiss) var dismiss

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                createFlow(state: &state)
                state.backgroundRunAllowed = appStorageManager.getRunInBackground()
                return .run { send in
                    await send(.setupTimerDestination)
                    await send(.setupNextActivity(0))
                    await send(.stateChanged(.preparation))
                }

            case .setupNextActivity(let index):
                state.currentActivity = state.workflow[index]
                return .none

            case .stateChanged(let newState):
                state.previousState = state.state
                state.state = newState
                return .run { [new = state.state] send in
                    switch new {
                    case .preparation, .running:
                        await send(.timerDestination(.presented(.timer(.startTimer))))

                    case .paused, .finished, .quit:
                        await send(.timerDestination(.presented(.timer(.stopTimer))))

                    default:
                        break
                    }
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
                return .run { send in
                    await send(.stateChanged(.quit))
                    await self.dismiss()
                }

            case .timerDestination(.presented(.timer(.delegate(.timerTick)))):
                if state.currentActivity != nil {
                    state.currentActivity!.interval -= state.timerTickInterval
                    if Constants.NotificationRange.contains(state.currentActivity!.interval) {
                        if appStorageManager.getSoundsEnabled() {
                            return .run { [interval = state.currentActivity!.interval] send in
                                await send(.playSound(.beep, Int(interval - 1)))
                            }
                        }
                        return .none
                    }
                    if state.currentActivity!.interval.isTimeElapsedZero() {
                        if appStorageManager.getSoundsEnabled() {
                            return .run { [isLastRunning = state.isLastRunning, interval = state.currentActivity!.interval] send in
                                await send(.playSound(isLastRunning ? .fanfare : .gong, Int(interval)))
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

            case .playSound(let sound, let numOfLoops):
                if soundManager.isPlaying(), soundManager.selectedSound() == sound {
                    return .none
                }
                soundManager.playSound(sound, numOfLoops)
                return .none

            case .timerDestination:
                return .none

            case .setupTimerDestination:
                state.timerDestination = .timer(TimingFeature.State(timerTickInterval: state.timerTickInterval))
                return .none
            }
        }
        .ifLet(\.$timerDestination, action: \.timerDestination)
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

extension WorkoutRunFeature {
    @Reducer
    enum TimerDestination {
        case timer(TimingFeature)
    }
}
