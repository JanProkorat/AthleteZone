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
    struct State: Equatable {
        var featureId = UUID()
        static func == (lhs: TimeTrackingFeature.State, rhs: TimeTrackingFeature.State) -> Bool {
            lhs.featureId == rhs.featureId
        }

        var displayedType: TimerType = .stopWatch
        var lastActivity: StopwatchDto?
        var lastTImer: TimeInterval = 0
        var timerStartValue: TimeInterval = 0

        var displayedTypeLabel: String {
            self.displayedType == .stopWatch ? LocalizationKey.stopWatch.stringValue : LocalizationKey.timer.stringValue
        }

        var lastTrackedTime: String {
            switch self.displayedType {
            case .stopWatch:
                guard let lastActivity = self.lastActivity else { return "_ _ / _ _" }
                return lastActivity.endDate.timeIntervalSince(lastActivity.startDate).toFormattedTimeForTimer()

            case .timer:
                return self.lastTImer.toFormattedTimeForTimer()
            }
        }

        var isRunDisabled: Bool {
            self.displayedType == .timer && self.timerStartValue == 0
        }

        @Presents var destination: Destination.State?
    }

    enum Action {
        case onAppear
        case sectionChanged(TimerType)
        case timerStartValueChanged(TimeInterval)
        case destination(PresentationAction<Destination.Action>)
        case startTapped
        case setLastActivity(StopwatchDto?)
    }

    @Dependency(\.timerActivityRepository) var timerActivityRepository
    @Dependency(\.stopWatchRepository) var stopWatchRepository
    @Dependency(\.appStorageManager) var appStorageManager
    @Dependency(\.appStateManager) var appStateManager

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                do {
                    let timer = try self.timerActivityRepository.load()
                    if let loadedTimer = timer {
                        state.lastTImer = loadedTimer.interval
                    }
                } catch {
                    print(error.localizedDescription)
                }
                state.displayedType = self.appStorageManager.getStopWatchType()
                return .send(.setLastActivity(self.stopWatchRepository.loadLast()))

            case .sectionChanged(let section):
                state.displayedType = section
                self.appStateManager.updateTitle("\(state.displayedType)")
                return .none

            case .timerStartValueChanged(let value):
                state.timerStartValue = value
                return .none

            case .destination(.presented(.runStopwatchSheet(.delegate(.save(let start, let end, let interval, let splitTimes))))):
                let activity = StopWatch(startDate: start, endDate: end, interval: interval, splitTimes: splitTimes)
                do {
                    try self.stopWatchRepository.add(activity)
                } catch {
                    print(error.localizedDescription)
                }
                return .send(.setLastActivity(activity.toDto()))

            case .destination:
                return .none

            case .startTapped:
                switch state.displayedType {
                case .stopWatch:
                    state.destination = .runStopwatchSheet(StopwatchRunFeature.State())
                    return .send(.destination(.presented(.runStopwatchSheet(.onAppear))))

                case .timer:
                    state.destination = .runTimerSheet(TimerRunFeature.State(timeRemaining: state.timerStartValue))
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
