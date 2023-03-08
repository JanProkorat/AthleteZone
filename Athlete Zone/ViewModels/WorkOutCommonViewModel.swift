//
//  WorkOutCommonViewModel.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 28.02.2023.
//

import Foundation
class WorkOutCommonViewModel {
    @Published var _id: String?
    @Published var name: String
    @Published var work: Int
    @Published var rest: Int
    @Published var series: Int
    @Published var rounds: Int
    @Published var reset: Int

    var isValid: Bool {
        return !name.isEmpty && work > 0 && rest > 0 && series > 0 && rounds > 0 && reset > 0
    }

    var timeOverview: Int {
        (((work * series) + (rest * (series - 1)) + reset) * rounds) - reset
    }

    init() {
        self.name = "Title"
        self.work = 30
        self.rest = 60
        self.series = 3
        self.rounds = 5
        self.reset = 60
    }

    init(name: String, work: Int, rest: Int, series: Int, rounds: Int, reset: Int, _id: String? = nil) {
        self._id = _id
        self.name = name
        self.work = work
        self.rest = rest
        self.series = series
        self.rounds = rounds
        self.reset = reset
    }

    func setValues(_ workout: WorkOut) {
        _id = workout._id.stringValue
        name = workout.name
        work = workout.work
        rest = workout.rest
        series = workout.series
        rounds = workout.rounds
        reset = workout.reset
    }

    func getProperty(for activityType: ActivityType) -> Int {
        switch activityType {
        case .work:
            return work

        case .rest:
            return rest

        case .series:
            return series

        case .rounds:
            return rounds

        case .reset:
            return reset
        }
    }
}
