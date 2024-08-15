//
//  TrackingRunFeature.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 12.03.2024.
//

import ComposableArchitecture
import Foundation

// swiftlint:disable enum_case_associated_values_count
// swiftlint:disable nesting
@Reducer
struct StopwatchRunFeature {
    @ObservableState
    struct State {
        var interval: TimeInterval = 0
        var splitTimes: [TimeInterval] = []
        var state: WorkFlowState = .ready
        var isTimerActive = false
        var backgroundRunAllowed = false
        var startDate = Date()
        var timerTickInterval = 0.01

        var isPaused: Bool {
            state == .paused
        }
    }

    enum Action {
        case onAppear
        case stateChanged(WorkFlowState)
        case pauseTapped
        case quitTapped
        case timerTicked
        case startTimer
        case stopTimer
        case setRunInBackground
        case addSplitTime
        case delegate(Delegate)

        enum Delegate: Equatable {
            case save(Date, Date, TimeInterval, [TimeInterval])
        }
    }

    enum CancelID {
        case stopWatchTimer
    }

    @Dependency(\.appStorageManager) var appStorageManager
    @Dependency(\.continuousClock) var clock
    @Dependency(\.dismiss) var dismiss
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.startDate = Date()
                return .send(.stateChanged(.running))

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
                    state.isTimerActive = false
                    return .run { [startDate = state.startDate, interval = state.interval, splitTimes = state.splitTimes] send in
                        await send(.stopTimer)
                        await send(.delegate(.save(startDate, Date(), interval, splitTimes)))
                    }

                default:
                    return .none
                }

            case .pauseTapped:
                return .run { [state = state.state] send in
                    await send(.stateChanged(state == .running ? .paused : .running))
                }

            case .quitTapped:
                return .run { send in
                    await send(.stateChanged(.quit))
                    await self.dismiss()
                }

            case .timerTicked:
                state.interval += state.timerTickInterval
                return .none

            case .startTimer:
                return .run { [isTimerActive = state.isTimerActive, interval = state.timerTickInterval] send in
                    guard isTimerActive else { return }
                    for await _ in self.clock.timer(interval: .seconds(interval)) {
                        await send(.timerTicked)
                    }
                }
                .cancellable(id: CancelID.stopWatchTimer, cancelInFlight: true)

            case .stopTimer:
                return .cancel(id: CancelID.stopWatchTimer)

            case .setRunInBackground:
                state.backgroundRunAllowed = appStorageManager.getRunInBackground()
                return .none

            case .addSplitTime:
                state.splitTimes.append(state.interval)
                return .none

            case .delegate:
                return .none
            }
        }
    }
}
