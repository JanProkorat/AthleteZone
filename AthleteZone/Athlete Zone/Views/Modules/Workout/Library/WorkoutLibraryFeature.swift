//
//  WorkoutLibraryFeature.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 23.02.2024.
//

import ComposableArchitecture
import Foundation

// swiftlint:disable pattern_matching_keywords
@Reducer
struct WorkoutLibraryFeature {
    @ObservableState
    struct State: Equatable {
        var featureId = UUID()
        static func == (lhs: WorkoutLibraryFeature.State, rhs: WorkoutLibraryFeature.State) -> Bool {
            lhs.featureId == rhs.featureId
        }

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

        case observeAddTapped
        case cancelAllObservers
    }

    enum CancelID {
        case observeAddTapped
    }

    @Dependency(\.appStorageManager) var appStorageManager
    @Dependency(\.appStateManager) var appStateManager
    @Dependency(\.workoutRepository) var workoutRepository

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                appStateManager.updateTitle("\(Tab.library)")
                return .run { send in
                    await send(.observeAddTapped)
                    await send(.displayData)
                }

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
                state.library = workoutRepository.getSortedData(state.searchText, state.sortBy, state.sortOrder)
                return .none

            case .destination(.presented(.addSheet(.delegate(.save(
                let name, let work, let rest, let series, let rounds, let reset
            ))))):
                if let workoutToEditId = state.workoutToEditId {
                    workoutRepository.update(workoutToEditId, name, work, rest, series, rounds, reset)
                    state.workoutToEditId = nil
                } else {
                    let workout = Workout(name, work, rest, series, rounds, reset)
                    workoutRepository.add(workout)
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
                appStateManager.updateTab(.home)
                return .none

            case .deleteTapped(let workoutId):
                if workoutRepository.isWorkoutAssignedToTraining(workoutId) {
                    state.workoutToDeleteId = workoutId
                    return .none
                }
                workoutRepository.delete(workoutId)
                return .send(.displayData)

            case .confirmDelete(let delete):
                if delete {
                    workoutRepository.delete(state.workoutToDeleteId!)
                }
                state.workoutToDeleteId = nil
                return .send(.displayData)

            case .observeAddTapped:
                return .run { send in
                    for await value in appStateManager.$saveTapped.values where value == true {
                        await send(.addTapped, animation: .default)
                    }
                }

            case .cancelAllObservers:
                return .cancel(id: CancelID.observeAddTapped)
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
