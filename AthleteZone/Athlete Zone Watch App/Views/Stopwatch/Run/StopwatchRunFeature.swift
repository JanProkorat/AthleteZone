//
//  StopwatchRunFeature.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 06.06.2024.
//

import ComposableArchitecture
import Foundation
import HealthKit

@Reducer
struct StopwatchRunFeature {
    @ObservableState
    struct State: Equatable {
        var id = UUID()
        static func == (lhs: StopwatchRunFeature.State, rhs: StopwatchRunFeature.State) -> Bool {
            lhs.id == rhs.id
        }

        /// Time displayed to the user - starts on
        var timeElapsed: TimeInterval = Constants.PreparationTickInterval

        /// Moc precize time interval for split times
        var preciseTimeElapsed: TimeInterval = Constants.PreparationTickInterval
        var splitTimes: [TimeInterval] = []
        var state: WorkFlowState = .ready
        var previousState: WorkFlowState = .ready
        var startDate = Date()
        var timerTickInterval = Constants.StopwatchTickInterval
        var selectedTab = 1
        var activityResult: ActivityResultDto?

        var isPaused: Bool {
            state == .paused
        }

        var actionLabel: LocalizationKey {
            return state == .preparation ? LocalizationKey.preparation :
                LocalizationKey.go
        }

        var formatedTime: String {
            if isPaused {
                if previousState == .preparation {
                    return timeElapsed.toFormattedTimeForWorkout()
                }
                return preciseTimeElapsed.toFormattedTime()
            }

            return timeElapsed.toFormattedTimeForWorkout()
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
        case addSplitTime
        case selectedTabChanged(Int)
        case timeElapsedChanged(TimeInterval)
        case setupDestinations
        case healthDestination(PresentationAction<HealthDestination.Action>)
        case timerDestination(PresentationAction<TimerDestination.Action>)
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

            case .pauseTapped:
                return .run { [state = state.state, previousState = state.previousState] send in
                    let newState = state == .running || state == .preparation ? .paused : previousState
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
                            totalEnergy: healthManager.getTotalEnergy())))
                }

            case .timerDestination(.presented(.timer(.delegate(.timerTick)))):
                if state.state == .preparation {
                    state.preciseTimeElapsed -= state.timerTickInterval
                    if state.preciseTimeElapsed.rounded(toPlaces: 2) == Double(state.timeElapsed - 1).rounded(toPlaces: 2) {
                        state.timeElapsed -= Constants.WorkoutTickInterval
                        if Constants.NotificationRange.contains(state.timeElapsed) {
                            return .run { _ in
                                hapticManager.playHaptic(.start)
                            }
                        }
                    }

                    if state.timeElapsed.isTimeElapsedZero() {
                        return .run { send in
                            if appStorageManager.getHapticsEnabled() {
                                hapticManager.playHaptic(.success)
                            }
                            await send(.stateChanged(.running))
                        }
                    }
                } else {
                    state.preciseTimeElapsed += state.timerTickInterval
                    if state.preciseTimeElapsed.rounded(toPlaces: 2) == Double(state.timeElapsed + 1).rounded(toPlaces: 2) {
                        state.timeElapsed += 1
                    }
                }
                return .none

            case .timeElapsedChanged(let value):
                state.timeElapsed = value
                return .none

            case .addSplitTime:
                state.splitTimes.append(state.preciseTimeElapsed)
                return .none

            case .selectedTabChanged(let tabIndex):
                state.selectedTab = tabIndex
                return .none

            case .healthDestination:
                return .none

            case .timerDestination:
                return .none

            case .setupDestinations:
                let accessStatus = healthManager.getAuthorizationStatus()
                state.healthDestination = .health(HealthFeature.State(
                    hkAccessStatus: accessStatus,
                    activityName: LocalizationKey.stopWatch.localizedKey))
                state.timerDestination = .timer(TimingFeature.State(timerTickInterval: state.timerTickInterval))
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

extension StopwatchRunFeature {
    @Reducer
    enum HealthDestination {
        case health(HealthFeature)
    }

    @Reducer
    enum TimerDestination {
        case timer(TimingFeature)
    }
}
