//
//  RealmManagerMock.swift
//  Athlete Zone Tests
//
//  Created by Jan Prokorát on 08.03.2023.
//

@testable import Athlete_Zone
import RealmSwift

class WorkOutRealmManagerMock: WorkOutRealmManagerProtocol {
    var objects: [WorkOut] = []

    func add(_ value: WorkOut) {
        objects.append(value)
    }

    func load(primaryKey: String) -> WorkOut? {
        do {
            let objectId = try ObjectId(string: primaryKey)
            return objects.first(where: { $0._id == objectId })
        } catch {
            return nil
        }
    }

    func load() -> [WorkOut] {
        return objects
    }

    func delete(entity: WorkOut) {
        let index = objects.firstIndex(where: { $0._id == entity._id })
        if let removeIndex = index {
            objects.remove(at: removeIndex)
        }
    }

    func update(
        _ id: RealmSwift.ObjectId,
        _ name: String,
        _ work: Int,
        _ rest: Int,
        _ series: Int,
        _ rounds: Int,
        _ reset: Int
    ) {
        guard let index = objects.firstIndex(where: { $0._id == id }) else {
            return
        }

        objects[index].name = name
        objects[index].work = work
        objects[index].rest = rest
        objects[index].series = series
        objects[index].rounds = rounds
        objects[index].reset = reset
    }

    func getSortedData(_ searchText: String, _ sortBy: WorkOutSortByProperty, _ sortOrder: SortOrder) -> [WorkOut] {
        return objects
    }
}
