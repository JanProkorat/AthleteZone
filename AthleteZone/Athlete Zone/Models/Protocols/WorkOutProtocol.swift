//
//  WorkOutProtocol.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 28.09.2023.
//

import Foundation

protocol WorkOutProtocol: Codable, Equatable {
    var name: String { get set }
    var work: Int { get set }
    var rest: Int { get set }
    var series: Int { get set }
    var rounds: Int { get set }
    var reset: Int { get set }
    var createdDate: Date { get set }
    var workFlow: [WorkFlow] { get }
}

extension WorkOutProtocol {
    var workFlow: [WorkFlow] {
        var flow: [WorkFlow] = []
        flow.append(WorkFlow(interval: 10, type: .preparation,
                             round: 1, serie: 1,
                             totalSeries: series, totalRounds: rounds))
        var serieCount = 1
        var interval = 0
        for round in 1 ... rounds {
            for serie in 1 ... (series + (series - 1)) {
                interval = serie.isOdd() ? work : rest
                if interval != 0 {
                    flow.append(
                        WorkFlow(
                            interval: interval - 1,
                            type: serie.isOdd() ? .work : .rest,
                            round: round,
                            serie: serieCount,
                            totalSeries: series,
                            totalRounds: rounds
                        )
                    )
                }
                if serie.isIven() {
                    serieCount += 1
                }
            }
            if round < rounds {
                flow.append(
                    WorkFlow(
                        interval: reset,
                        type: .reset,
                        round: round,
                        serie: flow[flow.count - 1].serie,
                        totalSeries: series,
                        totalRounds: rounds
                    )
                )
                serieCount = 1
            }
        }

        return flow
    }
}
