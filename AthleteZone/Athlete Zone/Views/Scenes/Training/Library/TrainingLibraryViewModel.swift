//
//  LibraryState.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 25.03.2023.
//

import Foundation
import SwiftUI
import WidgetKit

class TrainingLibraryViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var sortOrder: SortOrder = .ascending
    @Published var sortBy: TrainingSortByProperty = .name

    @ObservedObject var selectedTrainingManager = SelectedTrainingManager.shared
    @ObservedObject var router = ViewRouter.shared

    private var connectivityManager = WatchConnectivityManager.shared
    private var storageManager = AppStorageManager.shared

    var realmManager: TrainingRealmManagerProtocol

    var library: [Training] {
        realmManager.load(searchText, sortBy, sortOrder)
    }

    init() {
        realmManager = TrainingRealmManager()
    }

    func removeTraining(_ training: Training) {
        realmManager.delete(entity: training)
        objectWillChange.send()
        removeFromWatch(training._id.stringValue)

        if training._id == selectedTrainingManager.selectedTraining?._id {
            selectedTrainingManager.selectedTraining = nil
            storageManager.removeFromDefaults(key: UserDefaultValues.trainingId.rawValue)
            WidgetCenter.shared.reloadTimelines(ofKind: "RunningWorkoutWidget")
        }
    }

    func setSelectedTraining(_ id: String) {
        selectedTrainingManager.selectedTraining = library.first(where: { $0._id.stringValue == id })
    }

    func setSelectedTraining(_ training: Training) {
        selectedTrainingManager.selectedTraining = training
    }
}

// MARK: Watch connecctivity

extension TrainingLibraryViewModel {
    func removeFromWatch(_ id: String) {
        connectivityManager.sendValue(["training_remove": id])
    }
}
