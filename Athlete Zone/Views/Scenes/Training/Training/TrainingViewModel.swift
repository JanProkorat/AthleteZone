//
//  TrainingViewModel.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 04.04.2023.
//

import Combine
import Foundation
import SwiftUI

class TrainingViewModel: ObservableObject {
    @ObservedObject var selectedTrainingManager = SelectedTrainingManager.shared
    @ObservedObject var router = ViewRouter.shared
    var appStorageManager = AppStorageManager.shared

    @Published var selectedTraining: Training?
    @Published var workouts: [WorkOut] = []
    @Published var scenePhase: ScenePhase?

    private var cancellables = Set<AnyCancellable>()
    var realmManager: TrainingRealmManagerProtocol

    init() {
        realmManager = TrainingRealmManager()

        selectedTrainingManager.$selectedTraining
            .sink(receiveValue: { newValue in
                self.selectedTraining = newValue
                if newValue != nil {
                    self.workouts = Array(newValue!.workouts)
                }
            })
            .store(in: &cancellables)

        $scenePhase
            .sink { self.storeSelectedTrainingId($0) }
            .store(in: &cancellables)

        if selectedTrainingManager.selectedTraining == nil && !appStorageManager.selectedTrainingId.isEmpty {
            selectedTrainingManager.selectedTraining = realmManager.load(
                primaryKey: appStorageManager.selectedTrainingId
            )
        }
    }

    private func storeSelectedTrainingId(_ scenePhase: ScenePhase?) {
        if scenePhase != nil && (scenePhase == .inactive || scenePhase == .background) && selectedTraining != nil {
            appStorageManager.selectedTrainingId = selectedTraining!._id.stringValue
        }
    }
}
