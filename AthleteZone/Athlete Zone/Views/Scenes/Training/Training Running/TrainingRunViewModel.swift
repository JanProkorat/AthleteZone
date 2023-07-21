//
//  TrainingRunViewModel.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 23.04.2023.
//

import Combine
import Foundation
import SwiftUI

class TrainingRunViewModel: ObservableObject {
    @Published var trainingName: String
    @Published var workouts: [WorkOut]

    @Published var selectedWorkFlowViewModel: WorkFlowViewModel

    private var cancellables = Set<AnyCancellable>()

    init(training: Training) {
        trainingName = training.name
        workouts = Array(training.workouts)
        selectedWorkFlowViewModel = WorkFlowViewModel(workouts: Array(training.workouts))
    }
}