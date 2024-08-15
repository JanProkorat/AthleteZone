//
//  WorkoutContentFeature.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 21.02.2024.
//

import ComposableArchitecture
import Foundation

// swiftlint:disable nesting
@Reducer
struct WorkoutContentFeature {
    @ObservableState
    struct State: Equatable {
        static func == (lhs: WorkoutContentFeature.State, rhs: WorkoutContentFeature.State) -> Bool {
            lhs.currentTab == rhs.currentTab
        }

        var currentTab: Tab = .home

        @Presents var destination: Destination.State?
    }

    enum Action {
        case onAppear
        case tabChanged(Tab)
        case delegate(Delegate)
        case saveTapped
        case subscriptionActivated(Bool)
        case destination(PresentationAction<Destination.Action>)

        enum Delegate: Equatable {
            case switchTab(Tab)
            case setTitle(String)
            case subscriptionSheetVisibilityChanged
            case languageChanged(Language)
        }
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .send(.tabChanged(state.currentTab))

            case .tabChanged(let tab):
                state.currentTab = tab
                switch tab {
                case .home:
                    state.destination = .workout(WorkoutFeature.State())
                    return .send(.delegate(.switchTab(tab)))
                        .concatenate(with: .send(.destination(.presented(.workout(.onAppear)))))

                case .library:
                    state.destination = .library(WorkoutLibraryFeature.State())
                    return .send(.delegate(.switchTab(tab)))
                        .concatenate(with: .send(.destination(.presented(.library(.onAppear)))))

                case .settings:
                    state.destination = .settings(SettingsFeature.State())
                    return .send(.delegate(.switchTab(tab)))
                        .concatenate(with: .send(.destination(.presented(.settings(.onAppear)))))
                }

// MARK: Workout view actions

            case .destination(.presented(.workout(.delegate(.titleUpdated(let title))))):
                return .send(.delegate(.setTitle(title)))

// MARK: Library view actions

            case .destination(.presented(.library(.delegate(.workoutSelected)))):
                return .send(.tabChanged(.home))

            case .destination(.presented(.settings(.delegate(.seubscriptionSheetVisibilityChanged)))):
                return .send(.delegate(.subscriptionSheetVisibilityChanged))

// MARK: Settings view actions

            case .destination(.presented(.settings(.delegate(.languageChanged(let language))))):
                return .send(.delegate(.languageChanged(language)))

            case .delegate:
                return .none

            case .destination:
                return .none

            case .saveTapped:
                if state.currentTab == .home {
                    return .run { send in
                        await send(.destination(.presented(.workout(.saveTapped))))
                    }
                } else {
                    return .run { send in
                        await send(.destination(.presented(.library(.addTapped))))
                    }
                }

            case .subscriptionActivated(let activated):
                if state.currentTab != .settings {
                    return .none
                }
                return .send(.destination(.presented(.settings(.subscriptionChanged(activated)))))
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

extension WorkoutContentFeature {
    @Reducer
    enum Destination {
        case workout(WorkoutFeature)
        case library(WorkoutLibraryFeature)
        case settings(SettingsFeature)
    }
}
