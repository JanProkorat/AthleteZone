//
//  TrainingFeature.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 27.02.2024.
//

import ComposableArchitecture
import Foundation

// swiftlint:disable nesting
// swiftlint:disable pattern_matching_keywords
@Reducer
struct TrainingFeature {
    @ObservableState
    struct State {
        var selectedTraining: TrainingDto?
        var workoutForDetail: WorkoutDto?

        var isRunDisabled: Bool {
            selectedTraining != nil &&
                selectedTraining!.workouts.isEmpty
        }

        @Presents var destination: Destination.State?
    }

    enum Action {
        case onAppear
        case move(IndexSet, Int)
        case trainingChanged(TrainingDto?)
        case nameUpdated(String)
        case editTapped
        case addTapped
        case startTapped
        case libraryTapped
        case editSheetVisibilityChanged
        case workoutForDetailChanged(WorkoutDto?)
        case sentItemToWatch(TransferDataKey, TrainingDto)
        case destination(PresentationAction<Destination.Action>)
        case delegate(Delegate)

        enum Delegate: Equatable {
            case moveToLibrary
            case setTitle(String)
        }
    }

    @Dependency(\.trainingRealmManager) var realmManager
    @Dependency(\.appStorageManager) var appStorageManager
    @Dependency(\.watchConnectivityManager) var connectivityManager

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                if !appStorageManager.selectedTrainingId.isEmpty {
                    let training = realmManager.load(
                        primaryKey: appStorageManager.selectedTrainingId
                    )
                    return .send(.trainingChanged(training))
                }
                return .send(.nameUpdated(""))

            case .move(let from, let to):
                state.selectedTraining?.workouts.move(fromOffsets: from, toOffset: to)
                return .none

            case .trainingChanged(let training):
                state.selectedTraining = training
                appStorageManager.selectedTrainingId = training!.id
                return .send(.nameUpdated(training?.name ?? ""))

            case .nameUpdated(let name):
                return .send(.delegate(.setTitle(name)))

            case .editTapped:
                return .send(.editSheetVisibilityChanged)

            case .addTapped:
                return .send(.editSheetVisibilityChanged)

            case .startTapped:
                state.destination = .runSheet(TrainingRunFeature.State(
                    name: state.selectedTraining!.name,
                    workouts: state.selectedTraining!.workouts
                ))
                return .send(.destination(.presented(.runSheet(.onAppear))))

            case .libraryTapped:
                return .send(.delegate(.moveToLibrary))

            case .delegate:
                return .none

            case .destination(.presented(.editSheet(.delegate(.save(let name, let description, let workouts))))):
                let newWorkouts = workouts.map { dto in
                    WorkOut(dto.name,
                            dto.work,
                            dto.rest,
                            dto.series,
                            dto.rounds,
                            dto.reset)
                }
                if state.selectedTraining == nil {
                    let training = Training(name: name, description: description, workouts: newWorkouts)
                    realmManager.add(training)
                    return .send(.trainingChanged(training.toDto()))
                        .concatenate(with: .send(.sentItemToWatch(.trainingAdd, training.toDto())))
                }
                realmManager.update(state.selectedTraining!.id, name, description, newWorkouts)
                var training = state.selectedTraining
                training!.name = name
                training!.trainingDescription = description
                training!.workouts = workouts
                return .send(.trainingChanged(training))
                    .concatenate(with: .send(.sentItemToWatch(.trainingEdit, training!)))

            case .destination:
                return .none

            case .editSheetVisibilityChanged:
                if let training = state.selectedTraining {
                    state.destination = .editSheet(TrainingEditFeature.State(
                        headerText: .editTraining,
                        name: training.name,
                        description: training.trainingDescription,
                        workouts: training.workouts
                    ))
                } else {
                    state.destination = .editSheet(TrainingEditFeature.State(headerText: .addTraining))
                }
                return .none

            case .sentItemToWatch(let key, let data):
                return .run { _ in
                    connectivityManager.sendValue([key.rawValue: data.encode() ?? ""])
                }

            case .workoutForDetailChanged(let workout):
                state.workoutForDetail = workout
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

extension TrainingFeature {
    @Reducer
    enum Destination {
        case editSheet(TrainingEditFeature)
        case runSheet(TrainingRunFeature)
    }
}
