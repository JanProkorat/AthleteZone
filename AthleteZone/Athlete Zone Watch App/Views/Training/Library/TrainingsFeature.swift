//
//  TrainingsFeature.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 15.05.2024.
//

import ComposableArchitecture
import Foundation

@Reducer
struct TrainingsFeature {
    @ObservableState
    struct State: Equatable {
        var trainings: [TrainingDto] = []
        var selectedTraining: TrainingDto?
    }

    enum Action {
        case trainingSelected(TrainingDto?)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .trainingSelected(let training):
                state.selectedTraining = training
                return .none
            }
        }
    }
}
