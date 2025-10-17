//
//  WorkoutFeature.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 22.02.2024.
//

import ComposableArchitecture
import Foundation
import os

// swiftlint:disable pattern_matching_keywords
@Reducer
struct WorkoutFeature {
    @ObservableState
    struct State: Equatable {
        var featureId = UUID()
        static func == (lhs: WorkoutFeature.State, rhs: WorkoutFeature.State) -> Bool {
            lhs.featureId == rhs.featureId
        }

        var id: UUID?
        var name = ""
        var work = 30
        var rest = 60
        var series = 5
        var rounds = 3
        var reset = 60
        var timeOverview: Int {
            (((work * series) + (rest * series) + reset) * rounds) - reset
        }

        var isRunDisabled: Bool {
            work == 0 || rest == 0 || series == 0 || rounds == 0 || reset == 0
        }

        @Presents var destination: Destination.State?
    }

    enum Action {
        case onAppear
        case activitySelect(ActivityType)
        case intervalUpdated(ActivityType, Int)
        case idUpdated(UUID?)
        case destination(PresentationAction<Destination.Action>)
        case saveTapped
        case startTapped
        case workoutChanged(WorkoutDto?)

        case observeSaveTapped
        case cancelAllObservers
    }

    enum CancelID {
        case observeSaveTapped
    }

    @Dependency(\.appStorageManager) var appStorageManager
    @Dependency(\.workoutRepository) var workoutRepository
    @Dependency(\.appStateManager) var appStateManager
//    @Dependency(\.watchConnectivityManager) var connectivityManager

    private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: WorkoutFeature.self)
    )

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                if !appStorageManager.getSelectedWorkoutId().isEmpty {
                    let workout = workoutRepository.load(appStorageManager.getSelectedWorkoutId())
                    return
                        .run { send in
                            await send(.observeSaveTapped)
                            await send(.workoutChanged(workout))
                        }
                }
                appStateManager.updateTitle("")
                return .run { send in
                    await send(.observeSaveTapped)
                }

            case .workoutChanged(let workout):
                if workout == nil {
                    if appStateManager.title.isEmpty {
                        appStateManager.updateTitle("")
                    }
                    return .send(.idUpdated(nil))
                }
                appStorageManager.storeStringToAppStorage(workout!.id.uuidString, .selectedWorkoutId)
                appStateManager.updateTitle(workout!.name)

                state.work = workout!.work
                state.rest = workout!.rest
                state.series = workout!.series
                state.rounds = workout!.rounds
                state.reset = workout!.reset
                state.id = workout!.id

                return .none

            case .activitySelect(let type):
                state.destination = .activitySheet(ActivitySheetFeature.State(type: type, value: getProperty(for: type, state: &state)))
                return .none

            case .destination(.presented(.saveSheet(.delegate(.save(
                let name, let work, let rest, let series, let rounds, let reset
            ))))):
                let workout = Workout(name, work, rest, series, rounds, reset)
                workoutRepository.add(workout)
//                connectivityManager.sendValue([TransferDataKey.workoutAdd.rawValue: workout.toDto().encode() ?? ""])
                return .send(.workoutChanged(workout.toDto()))

            case .destination(.presented(.activitySheet(.delegate(.updateValue(let value, let type))))):
                return .send(.intervalUpdated(type, value))

            case .destination:
                return .none

            case .intervalUpdated(let type, let value):
                let updated = setInterval(type: type, value: value, state: &state)
                if updated {
                    appStateManager.updateTitle("")
                    return .send(.idUpdated(nil))
                }
                return .none

            case .idUpdated(let id):
                state.id = id
                return .none

            case .saveTapped:
                state.destination = .saveSheet(WorkoutEditFeature.State(
                    headerText: .saveWorkout,
                    name: state.name,
                    work: state.work,
                    rest: state.rest,
                    series: state.series,
                    rounds: state.rounds,
                    reset: state.reset
                ))
                return .none

            case .startTapped:
                state.destination = .runSheet(WorkoutRunFeature.State(
                    name: state.name,
                    work: state.work,
                    rest: state.rest,
                    series: state.series,
                    rounds: state.rounds,
                    reset: state.reset
                ))
                return .send(.destination(.presented(.runSheet(.onAppear))))

            case .observeSaveTapped:
                return .run { send in
                    for await value in appStateManager.$saveTapped.values where value == true {
                        await send(.saveTapped, animation: .default)
                    }
                }
                .cancellable(id: CancelID.observeSaveTapped)

            case .cancelAllObservers:
                return .cancel(id: CancelID.observeSaveTapped)
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }

    private func setInterval(type: ActivityType, value: Int, state: inout WorkoutFeature.State) -> Bool {
        switch type {
        case .work:
            if state.work != value {
                state.work = value
                return true
            }

        case .rest:
            if state.rest != value {
                state.rest = value
                return true
            }

        case .series:
            if state.series != value {
                state.series = value
                return true
            }

        case .rounds:
            if state.rounds != value {
                state.rounds = value
                return true
            }

        case .reset:
            if state.reset != value {
                state.reset = value
                return true
            }
        }
        return false
    }

    private func getProperty(for type: ActivityType, state: inout WorkoutFeature.State) -> Int {
        switch type {
        case .work:
            return state.work

        case .rest:
            return state.rest

        case .series:
            return state.series

        case .rounds:
            return state.rounds

        case .reset:
            return state.reset
        }
    }
}

extension WorkoutFeature {
    @Reducer
    enum Destination {
        case activitySheet(ActivitySheetFeature)
        case saveSheet(WorkoutEditFeature)
        case runSheet(WorkoutRunFeature)
    }
}
