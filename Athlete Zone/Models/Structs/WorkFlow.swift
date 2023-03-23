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
    var color: ComponentColor

    init(interval: Int, type: WorkFlowType, round: Int, serie: Int) {
        self.interval = interval
        self.type = type
        self.round = round
        self.serie = serie
        self.originalInterval = interval
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
        return Double(self.originalInterval - self.interval) / Double(self.originalInterval)
    }
}
