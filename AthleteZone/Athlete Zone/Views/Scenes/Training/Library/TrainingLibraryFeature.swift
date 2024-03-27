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
            case workoutSelected
        }
    }

    @Dependency(\.appStorageManager) var appStorageManager
    @Dependency(\.trainingRealmManager) var realmManager

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
                state.library = realmManager.load(state.searchText, state.sortBy, state.sortOrder)
                return .none

            case .destination(.presented(.addSheet(.delegate(.save(
                let name, let description, let workouts
            ))))):
                if let trainingId = state.trainingToEditId {
                    realmManager.update(trainingId, name, description, [])
                    state.trainingToEditId = nil
                } else {
                    let newWorkouts = workouts.map { dto in
                        WorkOut(dto.name,
                                dto.work,
                                dto.rest,
                                dto.series,
                                dto.rounds,
                                dto.reset)
                    }
                    realmManager.add(Training(name: name, description: description, workouts: newWorkouts))
                }
                return .send(.displayData)

            case .destination:
                return .none

            case .selectTapped(let trainingId):
                appStorageManager.selectedTrainingId = trainingId
                return .send(.delegate(.workoutSelected))

            case .deleteTapped(let trainingId):
                realmManager.delete(entityId: trainingId)
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
