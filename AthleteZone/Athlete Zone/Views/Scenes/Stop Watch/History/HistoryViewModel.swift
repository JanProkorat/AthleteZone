//
//  HistoryViewModel.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 30.11.2023.
//

import Foundation

class HistoryViewModel: ObservableObject {
    var router: any ViewRoutingProtocol
    var realmManager: any StopWatchRealmManagerProtocol

    @Published var searchText = ""
    @Published var sortOrder: SortOrder = .ascending
    @Published var sortBy: StopWatchSortByProperty = .name
    @Published var stopWatchToEdit: StopWatch?

    var library: [StopWatch] {
        realmManager.getSortedData(searchText, sortBy, sortOrder)
    }

    init() {
        router = ViewRouter.shared
        realmManager = StopWatchRealmManager()
    }

    func updateActivity(_ id: String, _ name: String) {
        realmManager.update(id, name)
    }

    func deleteActivities(at: IndexSet?) {
        if let index = at {
            realmManager.delete(at: index)
        }
    }
}
