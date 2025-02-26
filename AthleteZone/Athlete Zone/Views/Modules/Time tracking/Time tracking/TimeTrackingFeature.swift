//
//  TimeTrackingFeature.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 04.03.2024.
//

import ComposableArchitecture
import Foundation

// swiftlint:disable pattern_matching_keywords
@Reducer
struct TimeTrackingFeature {
    @ObservableState
    struct State {
        var displayedType: TimerType = .stopWatch
        var lastActivity: StopwatchDto?
        var timerStartValue: TimeInterval = 0
        var recentTimers: [TimerDto] = []
        @Presents var destination: Destination.State?
    }

    enum Action {
        case onAppear
        case sectionChanged(TimerType)
        case timerStartValueChanged(TimeInterval)
        case destination(PresentationAction<Destination.Action>)
        case startTapped(TimeInterval? = nil)
        case setLastActivity(StopwatchDto?)
    }

    @Dependency(\.timerActivityRepository) var timerActivityRepository
    @Dependency(\.stopWatchRepository) var stopWatchRepository
    @Dependency(\.appStorageManager) var appStorageManager

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                do {
                    state.recentTimers = try timerActivityRepository.load()
                } catch {
                    print(error.localizedDescription)
                }
                state.displayedType = appStorageManager.getStopWatchType()
                return .send(.setLastActivity(stopWatchRepository.loadLast()))

            case .sectionChanged(let section):
                state.displayedType = section
                return .none

            case .timerStartValueChanged(let value):
                state.timerStartValue = value
                return .none

            case .destination(.presented(.runStopwatchSheet(.delegate(.save(let start, let end, let interval, let splitTimes))))):
                let activity = StopWatch(startDate: start, endDate: end, interval: interval, splitTimes: splitTimes)
                do {
                    try stopWatchRepository.add(activity)
                } catch {
                    print(error.localizedDescription)
                }
                return .send(.setLastActivity(activity.toDto()))

            case .destination:
                return .none

            case .startTapped(let interval):
                switch state.displayedType {
                case .stopWatch:
                    state.destination = .runStopwatchSheet(StopwatchRunFeature.State())
                    return .send(.destination(.presented(.runStopwatchSheet(.onAppear))))

                case .timer:
                    if interval == nil {
                        do {
                            try timerActivityRepository.add(state.timerStartValue)
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                    state.destination = .runTimerSheet(
                        TimerRunFeature.State(
                            timeRemaining: interval == nil ? state.timerStartValue : interval!))
                    return .send(.destination(.presented(.runTimerSheet(.onAppear))))
                }

            case .setLastActivity(let activity):
                state.lastActivity = activity
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

extension TimeTrackingFeature {
    @Reducer
    enum Destination {
        case runStopwatchSheet(StopwatchRunFeature)
        case runTimerSheet(TimerRunFeature)
    }
}
