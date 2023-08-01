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

    @Published var selectedWorkFlowViewModel: WorkOutRunViewModel

    private var cancellables = Set<AnyCancellable>()

    init(trainingName: String, workouts: [WorkOut]) {
        self.trainingName = trainingName
        self.workouts = workouts
        selectedWorkFlowViewModel = WorkOutRunViewModel(workouts: workouts)
    }
}
