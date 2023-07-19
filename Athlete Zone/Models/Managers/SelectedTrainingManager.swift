//
//  SelectedTrainingManager.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 03.07.2023.
//

import Foundation

class SelectedTrainingManager: ObservableObject {
    static let shared = SelectedTrainingManager()

    @Published var selectedTraining: Training?
}
