//
//  WorkoutContentFeature.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 21.02.2024.
//

import ComposableArchitecture
import Foundation

@Reducer
struct WorkoutContentFeature {
    @ObservableState
    struct State: Equatable {
        var featureId = UUID()
        static func == (lhs: WorkoutContentFeature.State, rhs: WorkoutContentFeature.State) -> Bool {
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
        case cancelAllObservers
        case cancelTabChangeObserver
    }

    enum CancelID {
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
                .cancellable(id: CancelID.observeTabChange)

            case .tabChanged(let tab):
                state.currentTab = tab
                appStateManager.updateTab(tab)
                switch tab {
                case .home:
                    state.destination = .workout(WorkoutFeature.State())
                    return .send(.destination(.presented(.workout(.onAppear))))

                case .library:
                    state.destination = .library(WorkoutLibraryFeature.State())
                    return .send(.destination(.presented(.library(.onAppear))))

                case .settings:
                    state.destination = .settings(SettingsFeature.State())
                    return .send(.destination(.presented(.settings(.onAppear))))
                }

            case .destination:
                return .none

            case .cancelAllObservers:
                return .run { [tab = state.currentTab] send in
                    switch tab {
                    case .home:
                        await send(.destination(.presented(.workout(.cancelAllObservers))))

                    case .library:
                        await send(.destination(.presented(.library(.cancelAllObservers))))

                    case .settings:
                        break
                    }
                    await send(.cancelTabChangeObserver)
                }

            case .cancelTabChangeObserver:
                return .cancel(id: CancelID.observeTabChange)
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
