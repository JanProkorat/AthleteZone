//
//  TimerRealmManager.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 30.11.2023.
//

import Foundation
import RealmSwift

class StopWatchRealmManager: RealmManager, StopWatchRealmManagerProtocol {
    @ObservedResults(StopWatch.self) private var stopWatchLibrary

    func add(_ value: StopWatch) {
        $stopWatchLibrary.append(value)
    }

    func load(primaryKey: String) -> StopWatch? {
        do {
            let objectId = try ObjectId(string: primaryKey)
            return stopWatchLibrary.first(where: { $0._id == objectId })

        } catch {
            print(error.localizedDescription)
            return nil
        }
    }

    func load() -> [StopWatch] {
        var objects: [StopWatch] = []
        let queue = DispatchQueue(label: "realmQueue", qos: .background)
        queue.sync {
            objects = Array(realm.objects(StopWatch.self))
        }
        return objects
    }

    func delete(entity: StopWatch) {
        $stopWatchLibrary.remove(entity)
    }

    func getSortedData(_ searchText: String, _ sortBy: StopWatchSortByProperty, _ sortOrder: SortOrder) -> [StopWatch] {
        let filteredRecords: [StopWatch]
        if searchText.isEmpty {
            // If the search text is empty, return all records without filtering.
            filteredRecords = Array(stopWatchLibrary)
        } else {
            // Otherwise, filter based on the search text.
            filteredRecords = stopWatchLibrary.filter { stopWatch in
                stopWatch.name != nil && stopWatch.name!.lowercased().contains(searchText.lowercased())
            }
        }

        // Step 2: Sort the filtered list based on the selected `sortBy` and `sortOrder`.
        let sortedRecords: [StopWatch]
        switch sortBy {
        case .name:
            sortedRecords = filteredRecords.sorted { time1, time2 in
                sortOrder == .ascending ?
                    time1.name ?? "" < time2.name ?? "" :
                    time1.name ?? "" > time2.name ?? ""
            }

        case .startDate:
            sortedRecords = filteredRecords.sorted(by: { time1, time2 in
                sortOrder == .ascending ?
                    time1.startDate < time2.startDate :
                    time1.startDate > time2.startDate
            })

        case .endDate:
            sortedRecords = filteredRecords.sorted(by: { time1, time2 in
                sortOrder == .ascending ?
                    time1.endDate < time2.endDate :
                    time1.endDate > time2.endDate
            })

        case .activityLength:
            sortedRecords = filteredRecords.sorted(by: { time1, time2 in
                sortOrder == .ascending ?
                    (time1.endDate.timeIntervalSince(time1.startDate)) <
                    (time2.endDate.timeIntervalSince(time2.startDate)) :
                    (time1.endDate.timeIntervalSince(time1.startDate)) >
                    (time2.endDate.timeIntervalSince(time2.startDate))
            })
        }

        return sortedRecords
    }

    func update(_ id: String, _ name: String) {
        do {
            let entityId = try ObjectId(string: id)
            try realm.write {
                stopWatchLibrary.first { item in
                    item._id == entityId
                }!.name = name
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    func delete(at: IndexSet) {
        $stopWatchLibrary.remove(atOffsets: at)
    }
}
