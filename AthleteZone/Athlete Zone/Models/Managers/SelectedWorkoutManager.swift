//
//  SelectedWorkoutManager.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 03.03.2023.
//

import Foundation

class SelectedWorkoutManager: ObservableObject {
    static let shared = SelectedWorkoutManager()

    @Published var selectedWorkout: WorkOut?
}
