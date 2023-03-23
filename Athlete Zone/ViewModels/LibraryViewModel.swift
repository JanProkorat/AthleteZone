//
//  LibraryViewModel.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 01.03.2023.
//

import Combine
import RealmSwift
import SwiftUI

class LibraryViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var sortOrder: SortOrder = .ascending
    @Published var sortBy: SortByProperty = .name
    @Published var workoutToEdit: WorkOut?

    @ObservedObject var selectedWorkoutManager = SelectedWorkoutManager.shared
    @Published var connectivityManager = WatchConnectivityManager.shared
    var realmManager: WorkOutRealmManagerProtocol

    var library: [WorkOut] {
        realmManager.getSortedData(searchText, sortBy, sortOrder)
    }

    init() {
        realmManager = WorkoutRealmManager()
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
        selectedWorkoutManager.selectedWorkout = nil
        removeFromWatch(id)
    }
}

// MARK: Watch connecctivity

extension LibraryViewModel {
    func removeFromWatch(_ id: String) {
        connectivityManager.sendValue(["workout_remove": id])
    }
}
