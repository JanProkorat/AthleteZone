//
//  StopwatchFeature.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 21.05.2024.
//

import ComposableArchitecture
import Foundation

@Reducer
struct StopwatchFeature {
    @ObservableState
    struct State: Equatable {}

    enum Action {}

    var body: some ReducerOf<Self> {
        Reduce { _, action in
            switch action {}
        }
    }
}
