//
//  TrainingContentFeature.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 21.02.2024.
//

import ComposableArchitecture
import Foundation

@Reducer
struct TrainingContentFeature {
    @ObservableState
    struct State: Equatable {
        var featureId = UUID()
        static func == (lhs: TrainingContentFeature.State, rhs: TrainingContentFeature.State) -> Bool {
            lhs.featureId == rhs.featureId
        }

        var currentTab: Tab = .home

        @Presents var destination: Destination.State?
    }

    enum Action {
        case onAppear
        case tabChanged(Tab)
        case destination(PresentationAction<Destination.Action>)

        case observeTabChange
    }

    @Dependency(\.appStateManager) var appStateManager

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    await send(.observeTabChange)
                }

            case .observeTabChange:
                return .run { send in
                    for await value in appStateManager.$currentTab.values {
                        await send(.tabChanged(value), animation: .default)
                    }
                }

            case .tabChanged(let tab):
                state.currentTab = tab
                appStateManager.updateTab(tab)
                switch tab {
                case .home:
                    state.destination = .training(TrainingFeature.State())
                    return .send(.destination(.presented(.training(.onAppear))))

                case .library:
                    state.destination = .library(TrainingLibraryFeature.State())
                    return .send(.destination(.presented(.library(.onAppear))))

                case .settings:
                    state.destination = .settings(SettingsFeature.State())
                    return .send(.destination(.presented(.settings(.onAppear))))
                }

            case .destination:
                return .none
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
