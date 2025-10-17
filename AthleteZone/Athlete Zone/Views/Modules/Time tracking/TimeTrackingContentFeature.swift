//
//  TimeTrackingContentFeature.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 04.03.2024.
//

import ComposableArchitecture
import Foundation

@Reducer
struct TimeTrackingContentFeature {
    @ObservableState
    struct State: Equatable {
        var featureId = UUID()
        static func == (lhs: TimeTrackingContentFeature.State, rhs: TimeTrackingContentFeature.State) -> Bool {
            lhs.featureId == rhs.featureId
        }

        var currentTab: Tab = .home
        @Presents var destination: Destination.State?
    }

    enum Action {
        case onAppear
        case sectionChanged(TimerType)
        case tabChanged(Tab)
        case destination(PresentationAction<Destination.Action>)

        case observeSectionChange
        case observeTabChange
    }

    @Dependency(\.appStateManager) var appStateManager
    @Dependency(\.appStorageManager) var appStorageManager

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { [currentTab = state.currentTab] send in
                    await send(.observeSectionChange)
                    await send(.observeTabChange)
                    await send(.tabChanged(currentTab))
                    await send(.sectionChanged(appStorageManager.getStopWatchType()))
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
                    state.destination = .timeTracting(TimeTrackingFeature.State())
                    return .send(.destination(.presented(.timeTracting(.onAppear))))

                case .library:
                    state.destination = .library(HistoryFeature.State())
                    return .send(.destination(.presented(.library(.onAppear))))

                case .settings:
                    state.destination = .settings(SettingsFeature.State())
                    return .send(.destination(.presented(.settings(.onAppear))))
                }

            case .destination:
                return .none

            case .sectionChanged(let section):
                return .send(.destination(.presented(.timeTracting(.sectionChanged(section)))))

            case .observeSectionChange:
                return .run { send in
                    for await value in appStateManager.$timeTrackingType.values {
                        await send(.sectionChanged(value), animation: .default)
                    }
                }
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

extension TimeTrackingContentFeature {
    @Reducer
    enum Destination {
        case timeTracting(TimeTrackingFeature)
        case library(HistoryFeature)
        case settings(SettingsFeature)
    }
}
