//
//  LibraryViewModel.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 01.03.2023.
//

import Combine
import Foundation
import RealmSwift
import SwiftUI

class LibraryViewModel: ObservableObject {
    @ObservedResults(WorkOut.self) private var workOutLibrary
    @Published var searchText = ""
    @Published var sortOrder: SortOrder = .ascending
    @Published var sortBy: SortByProperty = .name
    @Published var workoutToEdit: WorkOut?
    @ObservedObject var selectedWorkoutManager = SelectedWorkoutManager.shared
    @Published var connectivityManager = WatchConnectivityManager.shared
    var library: [WorkOut] {
        applyFiltersAndSort(searchText, sortBy, sortOrder)
    }

    private var cancellables = Set<AnyCancellable>()
    private var notificationToken: NotificationToken?

    init() {
        notificationToken = workOutLibrary.observe { _ in
            self.objectWillChange.send()
        }
    }

    deinit {
        notificationToken?.invalidate()
    }

    func applyFiltersAndSort(_ searchText: String, _ sortBy: SortByProperty, _ sortOrder: SortOrder) -> [WorkOut] {
        if sortBy != .workoutLength {
            let data = workOutLibrary
                .sorted(byKeyPath: sortBy.rawValue.lowercased().toPascalCase(), ascending: sortOrder == .ascending)
            return applySearch(searchText, data)
        } else {
            let data = applySearch(searchText, workOutLibrary)
            return data.sorted(by: { work1, work2 in
                switch sortOrder {
                case .ascending:
                    return work1.workoutLength < work2.workoutLength

                default:
                    return work1.workoutLength > work2.workoutLength
                }
            })
        }
    }

    func applySearch(_ searchText: String, _ data: Results<WorkOut>) -> [WorkOut] {
        if !searchText.isEmpty {
            return Array(data.filter("name CONTAINS[c] %@", searchText))
        } else {
            return Array(data)
        }
    }
}

// MARK: Workout selection

extension LibraryViewModel {
    func setSelectedWorkOut(_ id: String) {
        selectedWorkoutManager.selectedWorkout = workOutLibrary.first(where: { $0._id.stringValue == id })
    }

    func setSelectedWorkOut(_ workout: WorkOut) {
        selectedWorkoutManager.selectedWorkout = workout
    }

    func removeWorkout(_ workout: WorkOut) {
        let id = workout._id.stringValue
        $workOutLibrary.remove(workout)
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
