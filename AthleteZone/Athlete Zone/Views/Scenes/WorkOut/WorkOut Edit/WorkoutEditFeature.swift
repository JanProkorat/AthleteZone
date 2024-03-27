//
//  SaveWorkoutFeature.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 23.02.2024.
//

import ComposableArchitecture
import Foundation

// swiftlint:disable nesting
// swiftlint:disable enum_case_associated_values_count
@Reducer
struct WorkoutEditFeature {
    @ObservableState
    struct State {
        var headerText: LocalizationKey
        var name = ""
        var work = 30
        var rest = 60
        var series = 5
        var rounds = 3
        var reset = 60
        var timeOverview: Int {
            (((work * series) + (rest * series) + reset) * rounds) - reset
        }

        var saveDisabled: Bool {
            name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                work == 0 || rest == 0 || series == 0 || rounds == 0 || reset == 0
        }

        var selectedType: ActivityType?
        var isActivitySheetVisible = false
    }

    enum Action {
        case cancelTapped
        case saveTapped
        case valueUpdated(Int)
        case nameUpdated(String)
        case activitySelect(ActivityType)
        case activitySheetVisibilityChanged(Bool)
        case delegate(Delegate)

        enum Delegate: Equatable {
            case save(String, Int, Int, Int, Int, Int)
        }
    }

    @Dependency(\.dismiss) var dismiss
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .cancelTapped:
                return .run { _ in await self.dismiss() }

            case .saveTapped:
                return .send(.delegate(.save(
                    state.name,
                    state.work,
                    state.rest,
                    state.series,
                    state.rounds,
                    state.reset))
                ).concatenate(with: .send(.cancelTapped))

            case .valueUpdated(let value):
                setInterval(value: value, state: &state)
                return .none

            case .nameUpdated(let name):
                state.name = name
                return .none

            case .activitySelect(let type):
                state.selectedType = type
                return .run { send in
                    await send(.activitySheetVisibilityChanged(true))
                }

            case .activitySheetVisibilityChanged(let isVisible):
                state.isActivitySheetVisible = isVisible
                return .none

            case .delegate:
                return .none
            }
        }
    }

    private func setInterval(value: Int, state: inout WorkoutEditFeature.State) {
        switch state.selectedType {
        case nil:
            break

        case .work:
            state.work = value

        case .rest:
            state.rest = value

        case .series:
            state.series = value

        case .rounds:
            state.rounds = value

        case .reset:
            state.reset = value
        }
    }

    private func getProperty(for activityType: ActivityType, state: inout WorkoutEditFeature.State) -> Int {
        switch activityType {
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
