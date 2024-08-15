//
//  ActivitySheetFeature.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 23.02.2024.
//

import ComposableArchitecture
import Foundation

@Reducer
struct ActivitySheetFeature {
    @ObservableState
    struct State {
        var type: ActivityType
        var value: Int
    }

    enum Action {
        case closeTapped
        case valueUpdated(Int)
        case delegate(Delegate)

        // swiftlint:disable nesting
        enum Delegate: Equatable {
            case updateValue(Int, ActivityType)
        }
        // swiftlint:enable nesting
    }

    @Dependency(\.dismiss) var dismiss
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .closeTapped:
                return .run { _ in
                    await self.dismiss()
                }

            case .valueUpdated(let value):
                state.value = value
                return .send(.delegate(.updateValue(value, state.type)))

            case .delegate:
                return .none
            }
        }
    }
}
