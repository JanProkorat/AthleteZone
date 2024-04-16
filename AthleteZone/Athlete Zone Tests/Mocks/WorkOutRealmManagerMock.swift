//
//  RealmManagerMock.swift
//  Athlete Zone Tests
//
//  Created by Jan Prokorát on 08.03.2023.
//

@testable import Athlete_Zone

class WorkOutRealmManagerMock: WorkOutRealmProtocol {
    var objects: [WorkOut] = []

    func add(_ value: WorkOut) {
        objects.append(value)
    }

    func load(primaryKey: String) -> WorkOut? {
        return objects.first(where: { $0.id == primaryKey })
    }

    func load() -> [WorkOut] {
        return objects
    }

    func delete(entityId: String) {
//        let index = objects.firstIndex(where: { $0._id == entity._id })
//        if let removeIndex = index {
//            objects.remove(at: removeIndex)
//        }
    }

    func update(
        _ id: String,
        _ name: String,
        _ work: Int,
        _ rest: Int,
        _ series: Int,
        _ rounds: Int,
        _ reset: Int
    ) {
        guard let index = objects.firstIndex(where: { $0.id == id }) else {
            return
        }

        objects[index].name = name
        objects[index].work = work
        objects[index].rest = rest
        objects[index].series = series
        objects[index].rounds = rounds
        objects[index].reset = reset
    }

    func getSortedData(_ searchText: String, _ sortBy: WorkOutSortByProperty, _ sortOrder: SortOrder) -> [WorkoutDto] {
        return objects.map { $0.toDto() }
    }

    func isWorkoutAssignedToTraining(_ id: String) -> Bool {
        return false
    }
}
