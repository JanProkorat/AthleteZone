//
//  ViewModel.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 10.01.2023.
//

import Combine
import Foundation

class ViewModel: ObservableObject {
    @Published var library: [WorkOut] = [WorkOut("Workout", 25, 10, 18, 1, 1)]
    @Published var settings: [String: Any]?
    @Published var selectedWorkOut: WorkOut?

    @Published var sortByProperty: SortByProperty = .name
    @Published var sortOrder: SortOrder = .ascending

    @Published var connectivityManager = WatchConnectivityManager.shared

    private var libraryCancellable: AnyCancellable?
    private var connectionStateCancellable: AnyCancellable?

    init() {
        libraryCancellable = connectivityManager.$receivedData.sink { newValue in
            if let lib = newValue {
                self.library = lib
            }
        }

        connectionStateCancellable = connectivityManager.$isSessionReachable.sink { newValue in
            if newValue {
                self.connectivityManager.requestData()
            }
        }
    }

    func setSelectedWorkOut(_ workout: WorkOut) {
        selectedWorkOut = workout
    }

    func setLibrary(_ workouts: [WorkOut]) {
        library = workouts
    }

    func getSortedArray() -> [WorkOut] {
        var result: [WorkOut]
        switch sortByProperty {
        case .name:
            result = library.sorted { $0.name > $1.name }

        case .work:
            result = library.sorted { $0.work > $1.work }

        case .rest:
            result = library.sorted { $0.rest > $1.rest }

        case .series:
            result = library.sorted { $0.series > $1.series }

        case .rounds:
            result = library.sorted { $0.rounds > $1.rounds }

        case .reset:
            result = library.sorted { $0.reset > $1.reset }

        case .createdDate:
            result = library.sorted { $0.createdDate > $1.createdDate }

        case .workoutLength:
            result = library.sorted { $0.workoutLength > $1.workoutLength }
        }

        return sortOrder == .ascending ? result.reversed() : result
    }
}
