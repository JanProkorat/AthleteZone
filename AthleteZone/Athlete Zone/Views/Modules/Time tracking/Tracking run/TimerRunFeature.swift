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
        /// Time changing every tick
        var timeRemaining: TimeInterval = Constants.PreparationTickInterval

        /// Initial time set when feature was creating
        var startTime: TimeInterval = 0
        var originalInterval: TimeInterval = 0
        var previousState: WorkFlowState = .ready
        var state: WorkFlowState = .ready
        var isTimerActive = false
        var backgroundRunAllowed = false
        var timerTickInterval: TimeInterval = Constants.TimerTickInterval

        var isPaused: Bool {
            state == .paused
        }

        @Presents var timerDestination: TimerDestination.State?
    }

    enum Action {
        case onAppear
        case stateChanged(WorkFlowState)
        case pauseTapped
        case quitTapped
        case resetTapped
        case playSound(Sound, Int)
        case forwardTapped
        case backTapped
        case setupDestination
        case timerDestination(PresentationAction<TimerDestination.Action>)
        case timeRemainingChanged(TimeInterval)
    }

    enum CancelID {
        case timerRunTimer
    }

    @Dependency(\.soundManager) var soundManager
    @Dependency(\.appStorageManager) var appStorageManager
    @Dependency(\.dismiss) var dismiss
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.originalInterval = state.timeRemaining
                state.backgroundRunAllowed = appStorageManager.getRunInBackground()
                return .run { send in
                    await send(.setupDestination)
                    await send(.stateChanged(.preparation))
                }

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

            case .pauseTapped:
                switch state.state {
                case .finished:
                    state.timeRemaining = 10
                    return .send(.stateChanged(.preparation))

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

            case .backTapped:
                state.timeRemaining = 10
                return .send(.stateChanged(.preparation))

            case .forwardTapped:
                state.timeRemaining = state.startTime
                return .send(.stateChanged(.running))

            case .resetTapped:
                state.timeRemaining = state.originalInterval
                if state.state == .finished {
                    return .send(.stateChanged(.ready))
                }
                return .none

            case .timerDestination(.presented(.timer(.delegate(.timerTick)))):
                state.timeRemaining -= state.timerTickInterval
                if Constants.NotificationRange.contains(state.timeRemaining) {
                    return .run { [interval = state.timeRemaining] send in
                        await send(.playSound(.beep, Int(interval - 1)))
                    }
                }
                if state.timeRemaining.isTimeElapsedZero() {
                    return .run { [state = state.state, remaining = state.startTime] send in
                        if appStorageManager.getSoundsEnabled() {
                            await send(.playSound(.fanfare, 0))
                        }
                        if state == .preparation {
                            await send(.timeRemainingChanged(remaining))
                            await send(.stateChanged(.running))
                        } else {
                            await send(.stateChanged(.finished))
                        }
                    }
                }
                return .none

            case .timeRemainingChanged(let interval):
                state.timeRemaining = interval
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
}

extension TimerRunFeature {
    @Reducer
    enum TimerDestination {
        case timer(TimingFeature)
    }
}
