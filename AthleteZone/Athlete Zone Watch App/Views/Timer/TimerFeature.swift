//
//  TimerFeature.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 21.05.2024.
//

import ComposableArchitecture
import Foundation

@Reducer
struct TimerFeature {
    @ObservableState
    struct State: Equatable {
        var selectedHours: Int = 0
        var selectedMins: Int = 0
        var selectedSecs: Int = 0
        var interval: TimeInterval = 0

        var runDisabled: Bool {
            interval == 0
        }
    }

    enum Action {
        case selectedHoursChanged(Int)
        case selectedMinutesChanged(Int)
        case selectedSecondsChanged(Int)
        case intervalChanged
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .selectedHoursChanged(let hours):
                state.selectedHours = hours
                return .send(.intervalChanged)

            case .selectedMinutesChanged(let minutes):
                state.selectedMins = minutes
                return .send(.intervalChanged)

            case .selectedSecondsChanged(let seconds):
                state.selectedSecs = seconds
                return .send(.intervalChanged)

            case .intervalChanged:
                state.interval = TimeInterval(state.selectedHours * 3600 + state.selectedMins * 60 + state.selectedSecs)
                return .none
            }
        }
    }
}
