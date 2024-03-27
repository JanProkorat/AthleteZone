//
//  WorkoutLibraryFeature.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 23.02.2024.
//

import ComposableArchitecture
import Foundation

// swiftlint:disable nesting
// swiftlint:disable pattern_matching_keywords
@Reducer
struct WorkoutLibraryFeature {
    @ObservableState
    struct State {
        var searchText = ""
        var sortBy = WorkOutSortByProperty.name
        var sortOrder = SortOrder.ascending
        var library: [WorkoutDto] = []
        var workoutToEditId = ""

        @Presents var destination: Destination.State?
    }

    enum Action {
        case onAppear
        case searchTextChanged(String)
        case sortByChanged(WorkOutSortByProperty)
        case sortOrderChanged(SortOrder)
        case displayData
        case destination(PresentationAction<Destination.Action>)
        case addTapped
        case editTapped(WorkoutDto)
        case selectTapped(String)
        case deleteTapped(String)
        case delegate(Delegate)

        enum Delegate: Equatable {
            case workoutSelected
        }
    }

    @Dependency(\.appStorageManager) var appStorageManager
    @Dependency(\.workoutRealmManager) var realmManager

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .send(.displayData)

            case .searchTextChanged(let text):
                state.searchText = text
                return .send(.displayData)

            case .sortByChanged(let sortBy):
                state.sortBy = sortBy
                return .send(.displayData)

            case .sortOrderChanged(let sortOrder):
                state.sortOrder = sortOrder
                return .send(.displayData)

            case .displayData:
                state.library = realmManager.getSortedData(state.searchText, state.sortBy, state.sortOrder)
                return .none

            case .delegate:
                return .none

            case .destination(.presented(.addSheet(.delegate(
                .save(let name, let work, let rest, let series, let rounds, let reset))))):
                if state.workoutToEditId.isEmpty {
                    let workout = WorkOut(name, work, rest, series, rounds, reset)
                    realmManager.add(workout)
                    return .send(.displayData)
                }
                realmManager.update(state.workoutToEditId, name, work, rest, series, rounds, reset)
                return .send(.displayData)

            case .destination:
                return .none

            case .addTapped:
                state.destination = .addSheet(WorkoutEditFeature.State(headerText: .addWorkout))
                return .none

            case .editTapped(let workout):
                state.workoutToEditId = workout.id
                state.destination = .addSheet(WorkoutEditFeature.State(
                    headerText: .editWorkout,
                    name: workout.name,
                    work: workout.work,
                    rest: workout.rest,
                    series: workout.series,
                    rounds: workout.rounds,
                    reset: workout.reset
                ))
                return .none

            case .selectTapped(let workoutId):
                appStorageManager.selectedWorkoutId = workoutId
                return .send(.delegate(.workoutSelected))

            case .deleteTapped(let workoutId):
                realmManager.delete(entityId: workoutId)
                return .send(.displayData)
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

extension WorkoutLibraryFeature {
    @Reducer
    enum Destination {
        case addSheet(WorkoutEditFeature)
    }
}
