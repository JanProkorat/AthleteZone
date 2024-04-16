//
//  TrainingContentFeature.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 21.02.2024.
//

import ComposableArchitecture
import Foundation

// swiftlint:disable nesting
@Reducer
struct TrainingContentFeature {
    @ObservableState
    struct State {
        var currentTab: Tab = .home

        @Presents var destination: Destination.State?
    }

    enum Action {
        case onAppear
        case tabChanged(Tab)
        case delegate(Delegate)
        case destination(PresentationAction<Destination.Action>)
        case saveTapped

        enum Delegate: Equatable {
            case switchSection(Section)
            case switchTab(Tab)
            case setTitle(String)
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
                    state.destination = .training(TrainingFeature.State())
                    return .send(.delegate(.switchTab(tab)))
                        .concatenate(with:
                            .send(.destination(.presented(.training(.onAppear)))))

                case .library:
                    state.destination = .library(TrainingLibraryFeature.State())
                    return .send(.delegate(.switchTab(tab)))
                        .concatenate(with:
                            .send(.destination(.presented(.library(.onAppear)))))

                case .settings:
                    state.destination = .settings(SettingsFeature.State())
                    return .send(.delegate(.switchTab(tab)))
                        .concatenate(with:
                            .send(.destination(.presented(.settings(.onAppear)))))
                }

            case .delegate:
                return .none

            case .destination(.presented(.training(.delegate(.moveToLibrary)))):
                return .run { send in
                    await send(.tabChanged(.library))
                    await send(.delegate(.switchTab(.library)))
                }

            case .destination(.presented(.library(.delegate(.workoutSelected)))):
                return .send(.tabChanged(.home))
                    .concatenate(with: .send(.delegate(.switchTab(.home))))

            case .destination(.presented(.training(.delegate(.setTitle(let title))))):
                return .send(.delegate(.setTitle(title)))

            case .destination(.presented(.settings(.delegate(.languageChanged(let language))))):
                return .send(.delegate(.languageChanged(language)))

            case .destination:
                return .none

            case .saveTapped:
                switch state.currentTab {
                case .library:
                    return .send(.destination(.presented(.library(.addTapped))))

                default:
                    return .send(.destination(.presented(.training(.editTapped))))
                }
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

extension TrainingContentFeature {
    @Reducer
    enum Destination {
        case training(TrainingFeature)
        case library(TrainingLibraryFeature)
        case settings(SettingsFeature)
    }
}
