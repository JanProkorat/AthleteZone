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
// swiftlint:disable pattern_matching_keywords
@Reducer
struct StopwatchRunFeature {
    @ObservableState
    struct State: Equatable {
        var featureId = UUID()
        static func == (lhs: StopwatchRunFeature.State, rhs: StopwatchRunFeature.State) -> Bool {
            lhs.featureId == rhs.featureId
        }

        /// Time displayed to the user - starts on
        var timeElapsed: TimeInterval = Constants.PreparationTickInterval

        /// Moc precize time interval for split times
        var preciseTimeElapsed: TimeInterval = Constants.PreparationTickInterval
        var splitTimes: [TimeInterval] = []
        var previousState: WorkFlowState = .ready
        var state: WorkFlowState = .ready
        var isTimerActive = false
        var backgroundRunAllowed = false
        var startDate = Date()
        var timerTickInterval = Constants.StopwatchTickInterval

        var isPaused: Bool {
            state == .paused
        }

        var isSplitButtonDisabled: Bool {
            state != .running
        }

        @Presents var timerDestination: TimerDestination.State?
    }

    enum Action {
        case onAppear
        case stateChanged(WorkFlowState)
        case pauseTapped
        case quitTapped
        case addSplitTime
        case playSound(Sound, Int)
        case setupDestination
        case timerDestination(PresentationAction<TimerDestination.Action>)
        case delegate(Delegate)

        enum Delegate: Equatable {
            case save(Date, Date, TimeInterval, [TimeInterval])
        }
    }

    enum CancelID {
        case stopWatchTimer
    }

    @Dependency(\.soundManager) var soundManager
    @Dependency(\.appStorageManager) var appStorageManager
    @Dependency(\.dismiss) var dismiss
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.startDate = Date()
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
                return .run { [state = state.state, previousState = state.previousState] send in
                    let newState = state == .running || state == .preparation ? .paused : previousState
                    await send(.stateChanged(newState), animation: .default)
                }

            case .quitTapped:
                return .run { [
                    state = state.state, previousState = state.previousState, startDate = state.startDate,
                    timeInterval = state.timerTickInterval, splitTimes = state.splitTimes
                ] send in
                    await send(.stateChanged(.quit))

                    if state == .running || previousState == .running {
                        await send(.delegate(.save(
                            startDate,
                            Date(),
                            timeInterval,
                            splitTimes))
                        )
                    }

                    await self.dismiss()
                }

            case .timerDestination(.presented(.timer(.delegate(.timerTick)))):
                if state.state == .preparation {
                    state.preciseTimeElapsed -= state.timerTickInterval
                    if state.preciseTimeElapsed.rounded(toPlaces: 2).isWholeNumber() {
                        state.timeElapsed -= Constants.WorkoutTickInterval
                        if Constants.NotificationRange.contains(state.timeElapsed) {
                            return .send(.playSound(.beep, Int(state.timeElapsed - 1)))
                        }
                    }

                    if state.timeElapsed.isTimeElapsedZero() {
                        // Set timeElapsed to exactly zero to ensure consistency
                        state.timeElapsed = 0
                        state.preciseTimeElapsed = 0

                        return .run { [timeElapsed = state.timeElapsed] send in
                            if appStorageManager.getSoundsEnabled() {
                                await send(.playSound(.gong, Int(timeElapsed)))
                            }
                            await send(.stateChanged(.running))
                        }
                    }
                } else {
                    state.preciseTimeElapsed += state.timerTickInterval
                    if state.preciseTimeElapsed.rounded(toPlaces: 2).isWholeNumber() {
                        state.timeElapsed += 1
                    }
                }
                return .none

            case .addSplitTime:
                state.splitTimes.append(state.preciseTimeElapsed)
                return .none

            case .delegate:
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

extension StopwatchRunFeature {
    @Reducer
    enum TimerDestination {
        case timer(TimingFeature)
    }
}
