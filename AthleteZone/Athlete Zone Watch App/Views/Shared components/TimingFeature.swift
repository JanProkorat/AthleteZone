//
//  TimerFeature.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 25.07.2024.
//

import ComposableArchitecture
import Foundation

// swiftlint:disable nesting
@Reducer
struct TimingFeature {
    @ObservableState
    struct State: Equatable {
        var timerTickInterval: TimeInterval
        var isTimerActive: Bool = false
    }

    enum Action {
        case startTimer
        case stopTimer
        case delegate(Delegate)

        enum Delegate: Equatable {
            case timerTick
        }
    }

    enum CancelID {
        case timer
    }

    @Dependency(\.continuousClock) var clock
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .startTimer:
                if state.isTimerActive {
                    return .none
                }
                state.isTimerActive.toggle()
                return .run { [interval = state.timerTickInterval] send in
                    for await _ in self.clock.timer(interval: .seconds(interval)) {
                        await send(.delegate(.timerTick))
                    }
                }
                .cancellable(id: CancelID.timer, cancelInFlight: true)

            case .stopTimer:
                if !state.isTimerActive {
                    return .none
                }
                state.isTimerActive.toggle()
                return .cancel(id: CancelID.timer)

            case .delegate:
                return .none
            }
        }
    }
}
