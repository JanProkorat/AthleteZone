//
//  ContentFeature.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 21.02.2024.
//

import ComposableArchitecture
import Foundation
import UIKit

@Reducer
struct ContentFeature {
    @ObservableState
    struct State: Equatable {
        var featureId = UUID()
        static func == (lhs: ContentFeature.State, rhs: ContentFeature.State) -> Bool {
            lhs.featureId == rhs.featureId
        }

        var currentSection: Section = .workout
        var currentLanguage: Language = .en
        var launchScreenState: LaunchScreenStep = .firstStep
        var currentTab: Tab = .home
        var timeTractingSection: TimerType = .stopWatch
        var subscriptionActivated = false
        var subscriptionSheetVisible = false
        var title = ""

        @Presents var destination: Destination.State?
        @Presents var subscriptionSheet: SubscriptionFeature.State?
    }

    enum Action {
        case onAppear
        case sectionChanged(Section)
        case languageChanged(Language)
        case launchScreenStateChanged(LaunchScreenStep)
        case tabChanged(Tab)
        case purchaseCompleted
        case subscriptionStatusChanged(Bool)
        case subscriptionSheetVisibilityChanged(Bool)
        case saveTapped
        case titleChanged(String)
        case timeTractingSectionChanged(TimerType)

        case destination(PresentationAction<Destination.Action>)
        case subscriptionSheet(PresentationAction<SubscriptionFeature.Action>)

        case observeTransactions
        case observeTitleChange
        case observeTabChange
        case observeLanguageChange
        case observeSubscriptionSheetVisibilityChange
        case cancelAllObservers
    }

    enum CancelID {
        case observeTitleChange
        case observeTabChange
        case observeLanguageChange
        case observeSubscriptionSheetVisibilityChange
    }

    @Dependency(\.appStorageManager) var appStorageManager
    @Dependency(\.appStateManager) var appStateManager
    @Dependency(\.notificationManager) var notificationManager
    @Dependency(\.subscriptionManager) var subscriptionManager

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                appStateManager.updateLanguage(appStorageManager.getLanguage())
                return .run { send in
                    let section = appStorageManager.getSelectedSection()
                    await send(.sectionChanged(section))
                    await send(.observeTabChange)
                    await send(.observeTitleChange)
                    await send(.observeLanguageChange)
                    await send(.observeSubscriptionSheetVisibilityChange)
                    if appStorageManager.getNotificationsEnabled() {
                        notificationManager.requestAuthorization()
                    }
                    await send(.launchScreenStateChanged(.secondStep))
                    try? await Task.sleep(for: Duration.seconds(1))
                    await send(.launchScreenStateChanged(.finished))
                }

            case .sectionChanged(let section):
                if section != state.currentSection || state.destination == nil {
                    state.currentSection = section
                    appStorageManager.storeSectionToAppStorage(section)
                    switch section {
                    case .workout:
                        state.destination = .workout(WorkoutContentFeature.State(currentTab: state.currentTab))
                        return .send(.destination(.presented(.workout(.onAppear))))

                    case .training:
                        state.destination = .training(TrainingContentFeature.State(currentTab: state.currentTab))
                        return .send(.destination(.presented(.training(.onAppear))))

                    case .stopWatch:
                        state.destination = .stopwatch(TimeTrackingContentFeature.State(currentTab: state.currentTab))
                        return .send(.destination(.presented(.stopwatch(.onAppear))))
                    }
                }
                return .none

            case .tabChanged(let tab):
                state.currentTab = tab
                appStateManager.updateTab(tab)
                return .none

            case .observeTitleChange:
                return .run { send in
                    for await value in appStateManager.$title.values {
                        await send(.titleChanged(value), animation: .default)
                    }
                }
                .cancellable(id: CancelID.observeTitleChange)

            case .observeLanguageChange:
                return .run { send in
                    for await value in appStateManager.$language.values {
                        await send(.languageChanged(value), animation: .default)
                    }
                }
                .cancellable(id: CancelID.observeLanguageChange)

            case .observeTabChange:
                return .run { send in
                    for await value in appStateManager.$currentTab.values {
                        await send(.tabChanged(value), animation: .default)
                    }
                }
                .cancellable(id: CancelID.observeTabChange)

            case .observeSubscriptionSheetVisibilityChange:
                return .run { send in
                    for await value in appStateManager.$isSubscriptionSheetVisible.values {
                        await send(.subscriptionSheetVisibilityChanged(value), animation: .default)
                    }
                }
                .cancellable(id: CancelID.observeSubscriptionSheetVisibilityChange)

            case .titleChanged(let title):
                state.title = title
                return .none

            case .languageChanged(let language):
                state.currentLanguage = language
                return .none

            case .subscriptionSheetVisibilityChanged(let visible):
                if visible {
                    state.subscriptionSheet = SubscriptionFeature.State()
                }
                return .none

            case .launchScreenStateChanged(let launchScreenState):
                state.launchScreenState = launchScreenState
                return .none

            case .timeTractingSectionChanged(let section):
                state.timeTractingSection = section
                appStorageManager.storeStopWatchTypeToAppStorage(section)
                appStateManager.updateTimeTrackingType(section)
                return .none

            case .destination:
                return .none

            case .observeTransactions:
                return .run { _ in
                    await subscriptionManager.observeTransactionUpdates()
                    await subscriptionManager.checkForUnfinishedTransactions()
                }

            case .subscriptionSheet:
                return .none

            case .purchaseCompleted:
                state.subscriptionSheet = nil
                return .none

            case .subscriptionStatusChanged(let activated):
                if activated == state.subscriptionActivated {
                    return .none
                }

                state.subscriptionActivated = activated
                subscriptionManager.subscriptionActivated = activated
                appStateManager.updateIsSubsccriptionActive(activated)
                return .none

            case .saveTapped:
                appStateManager.updateSaveTapped(true)
                return .none

            case .cancelAllObservers:
                return .cancel(id: [
                    CancelID.observeTitleChange,
                    CancelID.observeLanguageChange,
                    CancelID.observeTabChange,
                    CancelID.observeSubscriptionSheetVisibilityChange
                ])
            }
        }
        .ifLet(\.$destination, action: \.destination)
        .ifLet(\.$subscriptionSheet, action: \.subscriptionSheet) {
            SubscriptionFeature()
        }
    }
}

extension ContentFeature {
    @Reducer
    enum Destination {
        case workout(WorkoutContentFeature)
        case training(TrainingContentFeature)
        case stopwatch(TimeTrackingContentFeature)
    }
}
