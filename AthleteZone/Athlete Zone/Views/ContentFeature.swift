//
//  ContentFeature.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 21.02.2024.
//

import ComposableArchitecture
import Foundation

@Reducer
struct ContentFeature {
    @ObservableState
    struct State {
        var currentSection: Section = .workout
        var currentLanguage: Language = .en
        var launchScreenState: LaunchScreenStep = .firstStep
        var currentTab: Tab = .home
        var subscriptionActivated = false
        var subscriptionSheetVisible = false
        var title = ""
        var timeTractingSection: TimerType = .stopWatch

        @Presents var destination: Destination.State?
        @Presents var subscriptionSheet: SubscriptionFeature.State?
    }

    enum Action {
        case onAppear
        case sectionChanged(Section)
        case languageChanged(Language)
        case launchScreenStateChanged(LaunchScreenStep)
        case tabChanged(Tab)
        case observeTransactions
        case purchaseCompleted
        case subscriptionStatusChanged(Bool)
        case subscriptionSheetVisibilityChanged(Bool)
        case saveTapped
        case titleChanged(String)
        case timeTractingSectionChanged(TimerType)

        case destination(PresentationAction<Destination.Action>)
        case subscriptionSheet(PresentationAction<SubscriptionFeature.Action>)
    }

    @Dependency(\.appStorageManager) var appStorageManager
    @Dependency(\.notificationManager) var notificationManager
    @Dependency(\.subscriptionManager) var subscriptionManager

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    await send(.sectionChanged(appStorageManager.selectedSection))
                    await send(.timeTractingSectionChanged(appStorageManager.stopWatchType))
                    await send(.languageChanged(appStorageManager.language))
                    if appStorageManager.notificationsEnabled {
                        notificationManager.allowNotifications()
                    }
                    await send(.launchScreenStateChanged(.secondStep))
                    try? await Task.sleep(for: Duration.seconds(1))
                    await send(.launchScreenStateChanged(.finished))
                }

            case .sectionChanged(let section):
                if section != state.currentSection || state.destination == nil {
                    state.currentSection = section
                    appStorageManager.selectedSection = section
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
                            .concatenate(with: .send(.titleChanged("\(state.timeTractingSection)")))
                    }
                }
                return .none

            case .tabChanged(let tab):
                if tab != state.currentTab {
                    state.currentTab = tab
                    switch state.currentSection {
                    case .workout:
                        return .run { send in
                            if tab == .library || tab == .settings {
                                await send(.titleChanged("\(tab)"))
                            }
                            await send(.destination(.presented(.workout(.tabChanged(tab)))))
                        }

                    case .training:
                        return .run { send in
                            if tab == .library || tab == .settings {
                                await send(.titleChanged("\(tab)"))
                            }
                            await send(.destination(.presented(.training(.tabChanged(tab)))))
                        }

                    case .stopWatch:
                        return .run { [section = state.timeTractingSection] send in
                            if tab == .library || tab == .settings {
                                await send(.titleChanged("\(tab)"))
                            } else {
                                await send(.titleChanged(section.rawValue))
                            }
                            await send(.destination(.presented(.stopwatch(.tabChanged(tab)))))
                        }
                    }
                }
                if tab == .library || tab == .settings {
                    return .send(.titleChanged("\(tab)"))
                }
                return .none

            case .languageChanged(let language):
                state.currentLanguage = language
                appStorageManager.language = language
                return .none

            case .launchScreenStateChanged(let launchScreenState):
                state.launchScreenState = launchScreenState
                return .none

// MARK: Workout actions

            case .destination(.presented(.workout(.delegate(.setTitle(let title))))):
                return .send(.titleChanged(title))

            case .destination(.presented(.workout(.delegate(.switchTab(let tab))))):
                return .send(.tabChanged(tab))

            case .destination(.presented(.workout(.delegate(.subscriptionSheetVisibilityChanged)))):
                return .send(.subscriptionSheetVisibilityChanged(!state.subscriptionSheetVisible))

            case .destination(.presented(.workout(.delegate(.languageChanged(let language))))):
                return .send(.languageChanged(language))

// MARK: Training actions

            case .destination(.presented(.training(.delegate(.switchTab(let tab))))):
                return .send(.tabChanged(tab))

            case .destination(.presented(.training(.delegate(.setTitle(let title))))):
                return .send(.titleChanged(title))

            case .destination(.presented(.training(.delegate(.languageChanged(let language))))):
                return .send(.languageChanged(language))

// MARK: Tracking actions

            case .destination(.presented(.stopwatch(.delegate(.switchTab(let tab))))):
                return .send(.tabChanged(tab))

            case .destination(.presented(.stopwatch(.delegate(.languageChanged(let language))))):
                return .send(.languageChanged(language))

            case .timeTractingSectionChanged(let section):
                state.timeTractingSection = section
                appStorageManager.stopWatchType = section
                return .run { send in
                    await send(.destination(.presented(.stopwatch(.sectionChanged(section)))))
                    await send(.titleChanged(section.rawValue))
                }

            case .destination:
                return .none

            case .observeTransactions:
                return .run { _ in
                    await subscriptionManager.observeTransactionUpdates()
                    await subscriptionManager.checkForUnfinishedTransactions()
                }

            case .subscriptionSheet:
                return .none

            case .subscriptionSheetVisibilityChanged(let visible):
                if visible {
                    state.subscriptionSheet = SubscriptionFeature.State()
                }
                return .none

            case .purchaseCompleted:
                state.subscriptionSheet = nil
                return .none

            case .subscriptionStatusChanged(let activated):
                state.subscriptionActivated = activated
                subscriptionManager.subscriptionActivated = activated
                switch state.currentSection {
                case .workout:
                    return .send(.destination(.presented(.workout(.subscriptionActivated(activated)))))

                default:
                    return .none
                }

            case .saveTapped:
                switch state.currentSection {
                case .workout:
                    return .run { send in
                        await send(.destination(.presented(.workout(.saveTapped))))
                    }

                case .training:
                    return .run { send in
                        await send(.destination(.presented(.training(.saveTapped))))
                    }

                case .stopWatch:
                    break
                }
                return .none

            case .titleChanged(let title):
                state.title = title
                return .none
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
