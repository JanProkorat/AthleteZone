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
        var workoutToEditId: UUID?
        var workoutToDeleteId: UUID?

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
        case selectTapped(UUID)
        case deleteTapped(UUID)
        case confirmDelete(Bool)
        case delegate(Delegate)

        enum Delegate: Equatable {
            case workoutSelected
        }
    }

    @Dependency(\.appStorageManager) var appStorageManager
    @Dependency(\.workoutRepository) var repository

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
                state.library = repository.getSortedData(state.searchText, state.sortBy, state.sortOrder)
                return .none

            case .delegate:
                return .none

            case .destination(.presented(.addSheet(.delegate(
                .save(let name, let work, let rest, let series, let rounds, let reset))))):
                if let workoutToEditId = state.workoutToEditId {
                    repository.update(workoutToEditId, name, work, rest, series, rounds, reset)
                    state.workoutToEditId = nil
                } else {
                    let workout = Workout(name, work, rest, series, rounds, reset)
                    repository.add(workout)
                }
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
                appStorageManager.storeStringToAppStorage(workoutId.uuidString, .selectedWorkoutId)
                return .run { send in
                    await send(.delegate(.workoutSelected), animation: .default)
                }

            case .deleteTapped(let workoutId):
                if repository.isWorkoutAssignedToTraining(workoutId) {
                    state.workoutToDeleteId = workoutId
                    return .none
                }
                repository.delete(workoutId)
                return .send(.displayData)

            case .confirmDelete(let delete):
                if delete {
                    repository.delete(state.workoutToDeleteId!)
                }
                state.workoutToDeleteId = nil
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
