//
//  LibraryViewModel.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 01.03.2023.
//

import Combine
import RealmSwift
import SwiftUI
import WidgetKit

class LibraryViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var sortOrder: SortOrder = .ascending
    @Published var sortBy: WorkOutSortByProperty = .name
    @Published var workoutToEdit: WorkOut?

    @ObservedObject var selectedWorkoutManager = SelectedWorkoutManager.shared
    @ObservedObject var router = ViewRouter.shared
    private var storageManager = AppStorageManager.shared

    var realmManager: WorkOutRealmManagerProtocol
    var connectivityManager: WatchConnectivityProtocol

    var library: [WorkOut] {
        realmManager.getSortedData(searchText, sortBy, sortOrder)
    }

    init() {
        realmManager = WorkoutRealmManager()
        connectivityManager = WatchConnectivityManager.shared
    }
}

// MARK: Workout selection

extension LibraryViewModel {
    func setSelectedWorkOut(_ id: String) {
        selectedWorkoutManager.selectedWorkout = library.first(where: { $0._id.stringValue == id })
    }

    func setSelectedWorkOut(_ workout: WorkOut) {
        selectedWorkoutManager.selectedWorkout = workout
    }

    func removeWorkout(_ workout: WorkOut) {
        let id = workout._id.stringValue
        realmManager.delete(entity: workout)
        objectWillChange.send()
        removeFromWatch(id)

        if id == storageManager.selectedWorkoutId {
            selectedWorkoutManager.selectedWorkout = nil
            storageManager.removeFromDefaults(key: UserDefaultValues.workoutId)
            WidgetCenter.shared.reloadTimelines(ofKind: UserDefaultValues.widgetId.rawValue)
        }
    }

    func isWorkoutAssignedToTraining(id: String) -> Bool {
        return realmManager.isWorkoutAssignedToTraining(id)
    }
}

// MARK: Watch connecctivity

extension LibraryViewModel {
    func removeFromWatch(_ id: String) {
        connectivityManager.sendValue([TransferDataKey.workoutRemove.rawValue: id])
    }
}
