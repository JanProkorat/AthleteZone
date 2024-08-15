//
//  TimeTrackingContentFeature.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 04.03.2024.
//

import ComposableArchitecture
import Foundation

// swiftlint:disable nesting
@Reducer
struct TimeTrackingContentFeature {
    @ObservableState
    struct State {
        var currentTab: Tab = .home
        @Presents var destination: Destination.State?
    }

    enum Action {
        case onAppear
        case sectionChanged(TimerType)
        case tabChanged(Tab)
        case delegate(Delegate)
        case destination(PresentationAction<Destination.Action>)
        case subscriptionActivated(Bool)

        enum Delegate: Equatable {
            case switchTab(Tab)
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
                    state.destination = .timeTracting(TimeTrackingFeature.State())
                    return .send(.delegate(.switchTab(tab)))
                        .concatenate(with: .send(.destination(.presented(.timeTracting(.onAppear)))))

                case .library:
                    state.destination = .library(HistoryFeature.State())
                    return .send(.delegate(.switchTab(tab)))
                        .concatenate(with: .send(.destination(.presented(.library(.onAppear)))))

                case .settings:
                    state.destination = .settings(SettingsFeature.State())
                    return .send(.delegate(.switchTab(tab)))
                        .concatenate(with: .send(.destination(.presented(.settings(.onAppear)))))
                }

            case .destination(.presented(.settings(.delegate(.languageChanged(let language))))):
                return .send(.delegate(.languageChanged(language)))

            case .delegate:
                return .none

            case .destination:
                return .none

            case .sectionChanged(let section):
                return .send(.destination(.presented(.timeTracting(.sectionChanged(section)))))

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

extension TimeTrackingContentFeature {
    @Reducer
    enum Destination {
        case timeTracting(TimeTrackingFeature)
        case library(HistoryFeature)
        case settings(SettingsFeature)
    }
}
