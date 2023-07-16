//
//  LibraryState.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 25.03.2023.
//

import Foundation
import SwiftUI

class TrainingLibraryViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var sortOrder: SortOrder = .ascending
    @Published var sortBy: TrainingSortByProperty = .name

    @ObservedObject var selectedTrainingManager = SelectedTrainingManager.shared

    var realmManager: TrainingRealmManagerProtocol

    var library: [Training] {
        realmManager.load(searchText, sortBy, sortOrder)
    }

    init() {
        realmManager = TrainingRealmManager()
    }

    func removeTraining(_ training: Training) {
//        let id = training._id.stringValue
        realmManager.delete(entity: training)
        objectWillChange.send()
        selectedTrainingManager.selectedTraining = nil
//        removeFromWatch(id)
    }

    func setSelectedTraining(_ id: String) {
        selectedTrainingManager.selectedTraining = library.first(where: { $0._id.stringValue == id })
    }

    func setSelectedTraining(_ training: Training) {
        selectedTrainingManager.selectedTraining = training
    }
}
