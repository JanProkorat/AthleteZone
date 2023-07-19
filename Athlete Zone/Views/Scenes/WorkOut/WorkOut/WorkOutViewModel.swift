//
//  WorkOutViewModel.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 13.11.2022.
//

import Combine
import Foundation
import SwiftUI

class WorkOutViewModel: ObservableObject, Identifiable {
    @ObservedObject var selectedWorkoutManager = SelectedWorkoutManager.shared
    @ObservedObject var router = ViewRouter.shared

    var appStorageManager = AppStorageManager.shared

    @Published var selectedWorkout: WorkOut?
    @Published var name = "Title"
    @Published var work = 30
    @Published var rest = 60
    @Published var series = 5
    @Published var rounds = 3
    @Published var reset = 60
    @Published var scenePhase: ScenePhase?

    var timeOverview: Int {
        (((work * series) + (rest * (series - 1)) + reset) * rounds) - reset
    }

    private var cancellables = Set<AnyCancellable>()
    var realmManager: WorkOutRealmManagerProtocol

    init() {
        realmManager = WorkoutRealmManager()

        selectedWorkoutManager.$selectedWorkout
            .sink(receiveValue: { newValue in
                if let workout = newValue {
                    self.selectedWorkout = newValue
                    self.name = workout.name
                    self.work = workout.work
                    self.rest = workout.rest
                    self.series = workout.series
                    self.rounds = workout.rounds
                    self.reset = workout.reset
                }
            })
            .store(in: &cancellables)

        $scenePhase
            .sink { self.storeSelectedWorkoutId($0) }
            .store(in: &cancellables)

        if selectedWorkoutManager.selectedWorkout == nil && !appStorageManager.selectedWorkoutId.isEmpty {
            selectedWorkoutManager.selectedWorkout = realmManager.load(
                primaryKey: appStorageManager.selectedWorkoutId
            )
        }
    }

    private func storeSelectedWorkoutId(_ scenePhase: ScenePhase?) {
        if scenePhase != nil && (scenePhase == .inactive || scenePhase == .background) && selectedWorkout != nil {
            appStorageManager.selectedWorkoutId = selectedWorkout!._id.stringValue
        }
    }
}
