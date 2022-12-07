//
//  WorkFlow.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 15.11.2022.
//

import Foundation

struct WorkFlow {
    var interval: Int
    let type: ActivityType
    let round: Int
    let serie: Int
    let originalInterval: Int

    init(interval: Int, type: ActivityType, round: Int, serie: Int) {
        self.interval = interval
        self.type = type
        self.round = round
        self.serie = serie
        self.originalInterval = interval
    }

    mutating func setInterval(_ interval: Int) {
        self.interval = interval
    }

    func getProgress() -> Double {
        return Double(self.originalInterval - self.interval) / Double(self.originalInterval)
    }
}
