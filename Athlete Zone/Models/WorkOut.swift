//
//  WorkOut.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 10.11.2022.
//

import Foundation
import RealmSwift

class WorkOut: Object, Identifiable {
    @Persisted(primaryKey: true) var _id: ObjectId

    @Persisted var name: String = ""
    @Persisted var work: Int = 0
    @Persisted var rest: Int = 0
    @Persisted var series: Int = 0
    @Persisted var rounds: Int = 0
    @Persisted var reset: Int = 0

    override init() {
        name = "Title"
        work = 0
        rest = 0
        series = 0
        rounds = 0
        reset = 0
    }

    init(name: String, work: Int, rest: Int, series: Int, rounds: Int, reset: Int) {
        self.name = name
        self.work = work
        self.rest = rest
        self.series = series
        self.rounds = rounds
        self.reset = reset
    }

    var timeOverview: Int {
        ((work * series) + (rest * (series - 1)) + reset) * rounds
    }

    func setName(_ name: String) {
        self.name = name
    }

    func setWork(_ work: Int) {
        self.work = work
    }

    func setRest(_ rest: Int) {
        self.rest = rest
    }

    func setSeries(_ series: Int) {
        self.series = series
    }

    func setRounds(_ rounds: Int) {
        self.rounds = rounds
    }

    func setReset(_ reset: Int) {
        self.reset = reset
    }
}
