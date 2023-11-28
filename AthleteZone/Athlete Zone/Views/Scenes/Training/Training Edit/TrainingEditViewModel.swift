//
//  TrainingEditViewModel.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 09.07.2023.
//

import Foundation
import RealmSwift
import SwiftUI

class TrainingEditViewModel: ObservableObject {
    var training: Training
    @Published var name: String
    @Published var description: String
    @Published var workouts: [WorkOut]

    @Published var isEditing = false

    var saveDisabled: Bool {
        name.isEmpty || workouts.isEmpty
    }

    var trainingRealmManager: TrainingRealmManagerProtocol
    var workoutRealmManager: WorkOutRealmManagerProtocol

    @ObservedObject var selectedTrainingManager = SelectedTrainingManager.shared
    @Published var connectivityManager: WatchConnectivityProtocol
    var router: any ViewRoutingProtocol

    init() {
        let training = Training()
        self.training = training
        name = training.name
        description = training.trainingDescription
        workouts = Array(training.workouts)

        trainingRealmManager = TrainingRealmManager()
        workoutRealmManager = WorkoutRealmManager()
        router = ViewRouter.shared
        connectivityManager = WatchConnectivityManager.shared
    }

    init(training: Training) {
        self.training = training
        name = training.name
        description = training.trainingDescription
        workouts = Array(training.workouts)

        isEditing = true
        trainingRealmManager = TrainingRealmManager()
        workoutRealmManager = WorkoutRealmManager()
        router = ViewRouter.shared
        connectivityManager = WatchConnectivityManager.shared
    }

    init(name: String, description: String, workouts: [WorkOut]) {
        let realmWorkouts = RealmSwift.List<WorkOut>()
        realmWorkouts.append(objectsIn: workouts)
        training = Training(name: name, description: description, workouts: realmWorkouts)

        self.name = name
        self.description = description
        self.workouts = workouts

        trainingRealmManager = TrainingRealmManager()
        workoutRealmManager = WorkoutRealmManager()
        router = ViewRouter.shared
        connectivityManager = WatchConnectivityManager.shared
    }

    func saveTraining() {
        if !isEditing {
            training.name = name
            training.trainingDescription = description
            training.addWorkOuts(workouts)
            trainingRealmManager.add(training)
            connectivityManager.sendValue([TransferDataKey.trainingAdd.rawValue: training.toDto().encode() as Any])

            if router.currentTab == .home {
                selectedTrainingManager.selectedTraining = training
            }
        } else {
            trainingRealmManager.update(training._id, name, description, workouts)
            connectivityManager.sendValue([TransferDataKey.trainingEdit.rawValue: training.toDto().encode() as Any])

            if selectedTrainingManager.selectedTraining?._id == training._id {
                selectedTrainingManager.selectedTraining = training
            }
        }
    }
}
