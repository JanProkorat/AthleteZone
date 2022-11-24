//
//  WorkFlowViewModel.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 15.11.2022.
//

import Foundation

class WorkFlowViewModel: ObservableObject {
    @Published var flow: [WorkFlow] = [WorkFlow]()
    @Published var selectedFlow : WorkFlow? = nil

    @Published var selectedFlowIndex = 0
    @Published var seriesCount = 0
    @Published var roundsCount = 0
    
    init(workOut: WorkOut){
        createWorkFlow(workOut: workOut)
        selectedFlow = flow[selectedFlowIndex]
        seriesCount = workOut.series
        roundsCount = workOut.rounds
    }

    
    private func createWorkFlow(workOut: WorkOut) {
        var serie = 1
        for i in 1 ... workOut.rounds {
            for j in 1 ... (workOut.series + (workOut.series - 1)) {
                if j.isOdd(){
                    flow.append(WorkFlow(interval: workOut.work, type: .work, round: i, serie: serie))
                }else{
                    flow.append(WorkFlow(interval: workOut.rest, type: .rest, round: i, serie: serie))
                    serie += 1
                }
            }
            flow.append(WorkFlow(interval: workOut.rounds, type: .reset, round: i, serie: flow[flow.count - 1].serie))
            serie = 1
        }
    }
}
