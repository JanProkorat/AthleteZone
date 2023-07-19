//
//  WorkFlow.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 15.11.2022.
//

import Foundation

struct WorkFlow: Equatable {
    var interval: Int
    let type: WorkFlowType
    let round: Int
    let serie: Int
    let originalInterval: Int
    let totalSeries: Int
    let totalRounds: Int
    var color: ComponentColor

    var lastRound: Bool {
        round == totalRounds
    }

    var lastSerie: Bool {
        serie == totalSeries
    }

    init(interval: Int, type: WorkFlowType, round: Int, serie: Int, totalSeries: Int, totalRounds: Int) {
        self.interval = interval
        self.type = type
        self.round = round
        self.serie = serie
        self.originalInterval = interval
        self.totalRounds = totalRounds
        self.totalSeries = totalSeries
        self.color = .yellow
        switch type {
        case .work:
            self.color = .pink

        case .rest:
            self.color = .yellow

        default:
            self.color = .braun
        }
    }

    func getProgress() -> Double {
        return Double(originalInterval - interval) / Double(originalInterval)
    }
}
