//
//  ContentFeature.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 08.05.2024.
//

import Combine
import ComposableArchitecture
import Foundation

@Reducer
struct ContentFeature {
    @ObservableState
    struct State {
        var launchScreenState: LaunchScreenStep = .firstStep
        var isSessionReachable = false
        var workouts: [WorkoutDto] = []
        var trainings: [TrainingDto] = []
        var language: Language = .en
        var answerReceived = false
        var path = StackState<Path.State>()
    }

    enum Action {
        case onAppear
        case requestData
        case dataReceived([String: String]?)
        case checkIfanswerReceived
        case dismissLaunchScreen
        case launchScreenStateChanged(LaunchScreenStep)
        case decodeReceivedData(DefaultItem, String)
        case path(StackAction<Path.State, Path.Action>)
    }

    @Reducer(state: .equatable)
    enum Path {
        case workouts(WorkoutsFeature)
        case trainings(TrainingsFeature)
        case stopwatch(StopwatchFeature)
        case timer(TimerFeature)
        case workoutRun(WorkoutRunFeature)
        case trainingRun(TrainingRunFeature)
        case stopwatchRun(StopwatchRunFeature)
        case timerRun(TimerRunFeature)
    }

    @Dependency(\.watchConnectivityManager) var connectivityManager
    @Dependency(\.appStorageManager) var appStorageManager
    @Dependency(\.healthManager) var healthManager
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.language = appStorageManager.getLanguage()
                if healthManager.checkAuthorizationStatus() == .notDetermined {
                    healthManager.requestAuthorization()
                }
                if connectivityManager.isIosAppInstalled() {
                    return .none
                }
                return .run { send in
                    await send(.decodeReceivedData(.initData, appStorageManager.getBackUpData()))
                    await send(.dismissLaunchScreen)
                }

            case .dismissLaunchScreen:
                return .run { send in
                    await send(.launchScreenStateChanged(.secondStep))
                    try? await Task.sleep(for: Duration.seconds(1))
                    await send(.launchScreenStateChanged(.finished))
                }

            case .launchScreenStateChanged(let newStep):
                state.launchScreenState = newStep
                return .none

            case .requestData:
                connectivityManager.requestData()
                return .run { send in
                    try? await Task.sleep(for: Duration.seconds(5))
                    await send(.checkIfanswerReceived)
                }

            case .dataReceived(let receivedData):
                state.answerReceived.toggle()
                if let data = receivedData {
                    return .run { [launchScreenState = state.launchScreenState] send in
                        for message in data {
                            await send(.decodeReceivedData(DefaultItem(rawValue: message.key)!, message.value))
                        }
                        if launchScreenState != .finished {
                            await send(.dismissLaunchScreen)
                        }
                    }
                }
                if state.launchScreenState != .finished {
                    return .send(.dismissLaunchScreen)
                }
                return .none

            case .decodeReceivedData(let key, let data):
                switch key {
                case .initData:
                    appStorageManager.storeBackUpData(data)
                    let data = data.decode() as WatchDataDto?
                    state.workouts = data?.workouts ?? []
                    state.trainings = data?.trainings ?? []
                    return .none

                case .language:
                    let language = Language(rawValue: data) ?? appStorageManager.getLanguage()
                    appStorageManager.storeLanguage(language)
                    state.language = language
                    return .none

                case .hapticsEnabled:
                    appStorageManager.storeHapticsEnabled(Bool(data) ?? appStorageManager.getHapticsEnabled())
                    return .none

                default:
                    return .none
                }
            case .path:
                return .none

            case .checkIfanswerReceived:
                if !state.answerReceived {
                    return .run { send in
                        await send(.decodeReceivedData(.initData, appStorageManager.getBackUpData()))
                        await send(.dismissLaunchScreen)
                    }
                }
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}
