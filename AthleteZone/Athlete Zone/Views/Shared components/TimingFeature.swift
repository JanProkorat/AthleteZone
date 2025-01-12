//
//  TimerFeature.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 25.07.2024.
//

import BackgroundTasks
import ComposableArchitecture
import Foundation
import UIKit

// swiftlint:disable nesting
@Reducer
struct TimingFeature {
    @ObservableState
    struct State: Equatable {
        var timerTickInterval: TimeInterval
        var isTimerActive = false
        var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    }

    enum Action: Equatable {
        case startTimer
        case stopTimer
        case startTicking
        case startBackgroundTask
        case backgroundTaskStarted(UIBackgroundTaskIdentifier)
        case endBackgroundTask
        case delegate(Delegate)

        enum Delegate: Equatable {
            case timerTick
        }
    }

    enum CancelID {
        case timer
    }

    @Dependency(\.appStorageManager) var appStorageManager
    @Dependency(\.continuousClock) var clock
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .startTimer:
                if state.isTimerActive {
                    return .none
                }
                state.isTimerActive.toggle()

                if appStorageManager.getRunInBackground() {
                    return .merge(
                        .send(.startBackgroundTask),
                        .send(.startTicking))
                }

                return .send(.startTicking)

            case .stopTimer:
                if !state.isTimerActive {
                    return .none
                }
                state.isTimerActive.toggle()

                if appStorageManager.getRunInBackground() {
                    return .merge(
                        .send(.endBackgroundTask),
                        .cancel(id: CancelID.timer))
                }

                return .cancel(id: CancelID.timer)

            case .startTicking:
                return .run { [interval = state.timerTickInterval] send in
                    for await _ in self.clock.timer(interval: .seconds(interval)) {
                        await send(.delegate(.timerTick))
                    }
                }
                .cancellable(id: CancelID.timer, cancelInFlight: true)

            case .startBackgroundTask:
                return .run { send in
                    let task = await UIApplication.shared.beginBackgroundTask {
                        // This is the expiration handler
                        send(.endBackgroundTask)
                    }
                    await send(.backgroundTaskStarted(task))
                }

            case .backgroundTaskStarted(let taskId):
                state.backgroundTask = taskId
                return .none

            case .endBackgroundTask:
                if state.backgroundTask != .invalid {
                    UIApplication.shared.endBackgroundTask(state.backgroundTask)
                    state.backgroundTask = .invalid
                }
                return .none

            case .delegate:
                return .none
            }
        }
    }
}
