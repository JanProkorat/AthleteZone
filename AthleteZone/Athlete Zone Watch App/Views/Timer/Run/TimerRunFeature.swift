//
//  TimerRunFeature.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 02.07.2024.
//

import ComposableArchitecture
import Foundation
import HealthKit

@Reducer
struct TimerRunFeature {
    @ObservableState
    struct State: Equatable {
        var id = UUID()
        static func == (lhs: TimerRunFeature.State, rhs: TimerRunFeature.State) -> Bool {
            lhs.id == rhs.id
        }

        /// Time changing every tick
        var timeRemaining: TimeInterval = Constants.PreparationTickInterval

        /// Initial time set when feature was creating
        var startTime: TimeInterval = 0

        var timerTickInterval: TimeInterval = Constants.TimerTickInterval
        var state: WorkFlowState = .ready
        var previousState: WorkFlowState = .ready
        var startDate = Date()
        var selectedTab = 0
        var activityResult: ActivityResultDto?

        var isPaused: Bool {
            state == .paused
        }

        var actionLabel: LocalizationKey {
            if state == .finished {
                return LocalizationKey.finished
            }

            return state == .preparation ? LocalizationKey.preparation :
                LocalizationKey.go
        }

        var actionColor: ComponentColor {
            if state == .preparation || (isPaused && previousState == .preparation) {
                return ComponentColor.braun
            }

            return ComponentColor.lightPink
        }

        @Presents var healthDestination: HealthDestination.State?
        @Presents var timerDestination: TimerDestination.State?
    }

    enum Action {
        case onAppear
        case stateChanged(WorkFlowState)
        case pauseTapped
        case quitTapped
        case selectedTabChanged(Int)
        case setupDestinations
        case healthDestination(PresentationAction<HealthDestination.Action>)
        case timerDestination(PresentationAction<TimerDestination.Action>)
        case timeRemainingChanged(TimeInterval)
        case activityResultChanged(ActivityResultDto?)
    }

    @Dependency(\.healthManager) var healthManager
    @Dependency(\.hapticManager) var hapticManager
    @Dependency(\.appStorageManager) var appStorageManager
    @Dependency(\.dismiss) var dismiss
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.startDate = Date()
                return .run { send in
                    await send(.setupDestinations)
                    await send(.stateChanged(.preparation))
                }

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

            case .timerDestination(.presented(.timer(.delegate(.timerTick)))):
                state.timeRemaining -= state.timerTickInterval
                if Constants.NotificationRange.contains(state.timeRemaining) {
                    if appStorageManager.getHapticsEnabled() {
                        return .run { _ in
                            hapticManager.playHaptic(.start)
                        }
                    }
                }
                if state.timeRemaining.isTimeElapsedZero() {
                    return .run { [state = state.state, remaining = state.startTime] send in
                        if appStorageManager.getHapticsEnabled() {
                            hapticManager.playHaptic(.success)
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

            case .pauseTapped:
                return .run { [state = state.state, previousState = state.previousState] send in
                    let newState = state == .running || state == .preparation ? .paused :
                        state == .finished ? .preparation : previousState
                    await send(.stateChanged(newState), animation: .default)
                }

            case .quitTapped:
                return .run { send in
                    await send(.stateChanged(.quit))
                    await send(.activityResultChanged(
                        ActivityResultDto(
                            duration: healthManager.getWorkoutDuration(),
                            heartRate: healthManager.getAverageHeartRate(),
                            activeEnergy: healthManager.getActiveEnergy(),
                            totalEnergy: healthManager.getTotalEnergy()
                        )))
                }

            case .selectedTabChanged(let tabIndex):
                state.selectedTab = tabIndex
                return .none

            case .healthDestination:
                return .none

            case .setupDestinations:
                let accessStatus = healthManager.getAuthorizationStatus()
                let name = LocalizationKey.timer.localizedKey
                state.healthDestination = .health(HealthFeature.State(hkAccessStatus: accessStatus, activityName: name))
                state.timerDestination = .timer(TimingFeature.State(timerTickInterval: state.timerTickInterval))
                return .none

            case .timerDestination:
                return .none

            case .activityResultChanged(let result):
                state.activityResult = result
                if result == nil {
                    healthManager.resetWorkout()
                    return .run { _ in
                        await self.dismiss()
                    }
                }
                return .none
            }
        }
        .ifLet(\.$healthDestination, action: \.healthDestination)
        .ifLet(\.$timerDestination, action: \.timerDestination)
    }
}

extension TimerRunFeature {
    @Reducer
    enum HealthDestination {
        case health(HealthFeature)
    }

    @Reducer
    enum TimerDestination {
        case timer(TimingFeature)
    }
}
