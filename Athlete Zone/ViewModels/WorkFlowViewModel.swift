//
//  WorkFlowViewModel.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 15.11.2022.
//

import Foundation

class WorkFlowViewModel: ObservableObject {
    @Published var flow: [WorkFlow] = .init()
    @Published var selectedFlow: WorkFlow?

    @Published var selectedFlowIndex = 0
    @Published var seriesCount = 0
    @Published var roundsCount = 0

    var isLastRunning: Bool {
        selectedFlow != nil &&
            selectedFlow!.type == .work &&
            selectedFlow!.round == roundsCount &&
            selectedFlow!.serie == seriesCount
    }

    func createWorkFlow(workOut: WorkOut) {
        seriesCount = workOut.series
        roundsCount = workOut.rounds

        flow.append(WorkFlow(interval: 10, type: .preparation, round: 1, serie: 1))
        var serieCount = 1
        var interval = 0
        for round in 1 ... workOut.rounds {
            for serie in 1 ... (workOut.series + (workOut.series - 1)) {
                interval = serie.isOdd() ? workOut.work : workOut.rest
                if interval != 0 {
                    flow.append(
                        WorkFlow(
                            interval: interval,
                            type: serie.isOdd() ? .work : .rest,
                            round: round,
                            serie: serieCount
                        )
                    )
                }
                if serie.isIven() {
                    serieCount += 1
                }
            }
            if round < workOut.rounds {
                flow.append(
                    WorkFlow(
                        interval: workOut.reset,
                        type: .reset,
                        round: round,
                        serie: flow[flow.count - 1].serie
                    )
                )
                serieCount = 1
            }
        }

        selectedFlow = flow[selectedFlowIndex]
    }
}
