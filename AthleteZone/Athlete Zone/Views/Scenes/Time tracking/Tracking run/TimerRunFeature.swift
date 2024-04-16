//
//  TimerRunFeature.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 14.03.2024.
//

import ComposableArchitecture
import Foundation

// swiftlint:disable pattern_matching_keywords
@Reducer
struct TimerRunFeature {
    @ObservableState
    struct State {
        var interval: TimeInterval = 0
        var originalInterval: TimeInterval = 0
        var state: WorkFlowState = .ready
        var isTimerActive = false
        var backgroundRunAllowed = false
        var timerTickInterval: TimeInterval = 1

        var isPaused: Bool {
            state == .paused
        }
    }

    enum Action {
        case onAppear
        case stateChanged(WorkFlowState)
        case pauseTapped
        case quitTapped
        case resetTapped
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
                state.originalInterval = state.interval
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
                    return .send(.stopTimer)

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

            case .resetTapped:
                state.interval = state.originalInterval
                if state.state == .finished {
                    return .send(.stateChanged(.ready))
                }
                return .none

            case .timerTicked:
                state.interval -= state.timerTickInterval
                if state.interval <= 3, state.interval > 0 {
                    return .run { [interval = state.interval] send in
                        await send(.playSound(.beep, Int(interval - 1)))
                    }
                }
                if state.interval == 0 {
                    return .run { send in
                        await send(.stateChanged(.finished))
                        await send(.playSound(.fanfare, 0))
                    }
                }
                return .none

            case .startTimer:
                return .run { [isTimerActive = state.isTimerActive, interval = state.timerTickInterval] send in
                    guard isTimerActive else { return }
                    for await _ in self.clock.timer(interval: .seconds(interval)) {
                        await send(.timerTicked)
                    }
                }
                .cancellable(id: CancelID.timer, cancelInFlight: true)

            case .stopTimer:
                if soundManager.isSoundPlaying {
                    soundManager.stop()
                }
                return .cancel(id: CancelID.timer)

            case .playSound(let sound, let numOfLoops):
                if soundManager.isSoundPlaying, soundManager.selectedSound == sound {
                    return .none
                }
                soundManager.playSound(sound: sound, numOfLoops: numOfLoops)
                return .none

            case .setRunInBackground:
                state.backgroundRunAllowed = appStorageManager.getRunInBackground()
                return .none
            }
        }
    }
}
