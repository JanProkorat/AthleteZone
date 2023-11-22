//
//  TrainingViewModel.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 04.04.2023.
//

import Combine
import Foundation
import SwiftUI
import WidgetKit

class TrainingViewModel: ObservableObject {
    @ObservedObject var selectedTrainingManager = SelectedTrainingManager.shared
    @ObservedObject var runViewModel = TrainingRunViewModel()
    var router: any ViewRoutingProtocol
    var realmManager: TrainingRealmManagerProtocol
    var appStorageManager: any AppStorageProtocol

    @Published var selectedTraining: Training?
    @Published var workouts: [WorkOut] = []
    @Published var scenePhase: ScenePhase?
    @Published var isRunViewVisible = false

    private var cancellables = Set<AnyCancellable>()

    init() {
        realmManager = TrainingRealmManager()
        router = ViewRouter.shared
        appStorageManager = AppStorageManager.shared

        selectedTrainingManager.$selectedTraining
            .sink(receiveValue: { newValue in
                self.selectedTraining = newValue
                if newValue != nil {
                    self.workouts = Array(newValue!.workouts)
                    self.storeWidgetData()
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

        runViewModel.$closeSheet
            .sink { newValue in
                if newValue {
                    self.isRunViewVisible.toggle()
                }
            }
            .store(in: &cancellables)
    }

    private func storeSelectedTrainingId(_ scenePhase: ScenePhase?) {
        if scenePhase != nil && (scenePhase == .inactive || scenePhase == .background) && selectedTraining != nil {
            appStorageManager.selectedTrainingId = selectedTraining!._id.stringValue
        }
    }

    func setupRunViewModel() {
        runViewModel.setupViewModel(
            trainingName: selectedTraining?.name,
            workouts: workouts
        )
        isRunViewVisible.toggle()
    }

    func storeWidgetData() {
        if let data = selectedTraining?.toDto().encode() {
            appStorageManager.storeToUserDefaults(data: data, key: UserDefaultValues.trainingId)
            WidgetCenter.shared.reloadTimelines(ofKind: UserDefaultValues.widgetId.rawValue)
        }
    }
}
