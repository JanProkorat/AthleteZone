//
//  TrainingViewModel.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 04.04.2023.
//

import Foundation
class TrainingViewModel: ObservableObject {
    @Published var training: Training = .init()
}
