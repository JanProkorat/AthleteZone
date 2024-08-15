//
//  TrainingLibraryFeature.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 01.03.2024.
//

import ComposableArchitecture
import Foundation

// swiftlint:disable nesting
// swiftlint:disable pattern_matching_keywords
@Reducer
struct TrainingLibraryFeature {
    @ObservableState
    struct State {
        var searchText = ""
        var sortBy = TrainingSortByProperty.name
        var sortOrder = SortOrder.ascending
        var library: [TrainingDto] = []
        var trainingToEditId: String?

        @Presents var destination: Destination.State?
    }

    enum Action {
        case onAppear
        case searchTextChanged(String)
        case sortByChanged(TrainingSortByProperty)
        case sortOrderChanged(SortOrder)
        case displayData
        case selectTapped(String)
        case editTapped(TrainingDto)
        case addTapped
        case deleteTapped(String)
        case destination(PresentationAction<Destination.Action>)
        case delegate(Delegate)

        enum Delegate: Equatable {
            case trainingSelected
        }
    }

    @Dependency(\.appStorageManager) var appStorageManager
    @Dependency(\.trainingRepository) var trainingRepository

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
                state.library = trainingRepository.getSortedData(state.searchText, state.sortBy, state.sortOrder)
                return .none

            case .destination(.presented(.addSheet(.delegate(.save(
                let name, let description, let workouts
            ))))):
                let newWorkouts = workouts.map { WorkoutInfo(workoutId: $0.id, workoutLength: $0.workoutLength) }
                do {
                    if let trainingId = state.trainingToEditId {
                        try trainingRepository.update(trainingId, name, description, newWorkouts)
                        state.trainingToEditId = nil
                    } else {
                        try trainingRepository.add(
                            Training(
                                name: name,
                                description: description,
                                workouts: newWorkouts
                            ))
                    }
                } catch {
                    print(error.localizedDescription)
                }
                return .send(.displayData)

            case .destination:
                return .none

            case .selectTapped(let trainingId):
                appStorageManager.storeStringToAppStorage(trainingId, .selectedTrainingId)
                return .run { send in
                    await send(.delegate(.trainingSelected), animation: .default)
                }

            case .deleteTapped(let trainingId):
                do {
                    try trainingRepository.delete(trainingId)
                } catch {
                    print(error.localizedDescription)
                }
                return .send(.displayData)

            case .delegate:
                return .none

            case .editTapped(let training):
                state.trainingToEditId = training.id
                state.destination = .addSheet(TrainingEditFeature.State(
                    headerText: .editTraining,
                    name: training.name,
                    description: training.trainingDescription,
                    workouts: training.workouts
                ))
                return .none

            case .addTapped:
                state.destination = .addSheet(TrainingEditFeature.State(headerText: .addTraining))
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

extension TrainingLibraryFeature {
    @Reducer
    enum Destination {
        case addSheet(TrainingEditFeature)
    }
}
