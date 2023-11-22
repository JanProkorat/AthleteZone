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
    var router: any ViewRoutingProtocol
    var connectivityManager: WatchConnectivityProtocol
    var storageManager: any AppStorageProtocol

    var realmManager: TrainingRealmManagerProtocol

    var library: [Training] {
        realmManager.load(searchText, sortBy, sortOrder)
    }

    init() {
        realmManager = TrainingRealmManager()
        router = ViewRouter.shared
        connectivityManager = WatchConnectivityManager.shared
        storageManager = AppStorageManager.shared
    }

    func removeTraining(_ training: Training) {
        realmManager.delete(entity: training)
        objectWillChange.send()
        connectivityManager.sendValue(["training_remove": training._id.stringValue])

        if training._id == selectedTrainingManager.selectedTraining?._id {
            selectedTrainingManager.selectedTraining = nil
            storageManager.removeFromDefaults(key: UserDefaultValues.trainingId)
            WidgetCenter.shared.reloadTimelines(ofKind: UserDefaultValues.widgetId.rawValue)
        }
    }

    func setSelectedTraining(_ id: String) {
        selectedTrainingManager.selectedTraining = library.first(where: { $0._id.stringValue == id })
    }

    func setSelectedTraining(_ training: Training) {
        selectedTrainingManager.selectedTraining = training
    }
}
