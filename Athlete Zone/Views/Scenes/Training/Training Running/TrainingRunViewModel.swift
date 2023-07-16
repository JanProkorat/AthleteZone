//
//  TrainingRunViewModel.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 23.04.2023.
//

import Combine
import Foundation

class TrainingRunViewModel: ObservableObject {
    @Published var trainingName = ""
    @Published var workouts: [WorkOut] = []

    @Published var selectedWorkFlowViewModel = WorkFlowViewModel()

    private var cancellables = Set<AnyCancellable>()

    func initTraining(name: String, workouts: [WorkOut]) {
        trainingName = name
        self.workouts = workouts

        selectedWorkFlowViewModel.createWorkFlow(workouts)
    }
}
