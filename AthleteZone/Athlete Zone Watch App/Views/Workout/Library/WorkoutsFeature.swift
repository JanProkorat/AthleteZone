//
//  WorkoutsFeature.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 14.05.2024.
//

import ComposableArchitecture
import Foundation

@Reducer
struct WorkoutsFeature {
    @ObservableState
    struct State: Equatable {
        var workouts: [WorkoutDto] = []
        var selectedWorkout: WorkoutDto?
    }

    enum Action {
        case workoutSelected(WorkoutDto?)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .workoutSelected(let workout):
                state.selectedWorkout = workout
                return .none
            }
        }
    }
}
