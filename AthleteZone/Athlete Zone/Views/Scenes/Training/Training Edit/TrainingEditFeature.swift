//
//  TrainingEditFeature.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 29.02.2024.
//

import ComposableArchitecture
import Foundation

// swiftlint:disable nesting
// swiftlint:disable enum_case_associated_values_count
// swiftlint:disable pattern_matching_keywords
@Reducer
struct TrainingEditFeature {
    @ObservableState
    struct State {
        var headerText: LocalizationKey
        var name = ""
        var description = ""
        var workouts: [WorkoutDto] = []
        var saveDisabled: Bool {
            name.isEmpty || workouts.isEmpty
        }

        var workoutsLibrary: [WorkoutDto] = []
        var isWorkoutsSheetVisible = false
    }

    enum Action {
        case saveTapped
        case cancelTapped
        case nameUpdated(String)
        case descriptionUpdated(String)
        case addWorkoutsTapped
        case selectedWorkoutsChanged([WorkoutDto])
        case sheetVisibleChanged(Bool)
        case move(IndexSet, Int)
        case remove(IndexSet)
        case delegate(Delegate)

        enum Delegate: Equatable {
            case save(String, String, [WorkoutDto])
        }
    }

    @Dependency(\.workoutRepository) var realmManager
    @Dependency(\.dismiss) var dismiss
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .saveTapped:
                return .send(.delegate(.save(state.name, state.description, state.workouts)))
                    .concatenate(with: .send(.cancelTapped))

            case .cancelTapped:
                return .run { _ in await self.dismiss() }

            case .delegate:
                return .none

            case .nameUpdated(let name):
                state.name = name
                return .none

            case .descriptionUpdated(let description):
                state.description = String(description.prefix(200))
                return .none

            case .addWorkoutsTapped:
                return .send(.sheetVisibleChanged(true))

            case .sheetVisibleChanged(let visible):
                if visible {
                    do {
                        state.workoutsLibrary = try realmManager.getSortedData("", .name, .ascending)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
                state.isWorkoutsSheetVisible = visible
                return .none

            case .selectedWorkoutsChanged(let data):
                state.workouts = data
                return .none

            case .move(let from, let to):
                state.workouts.move(fromOffsets: from, toOffset: to)
                return .none

            case .remove(let index):
                state.workouts.remove(atOffsets: index)
                return .none
            }
        }
    }
}
