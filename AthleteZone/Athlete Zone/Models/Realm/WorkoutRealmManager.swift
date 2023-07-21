//
//  RealmManager.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 24.11.2022.
//

import Realm
import RealmSwift

class WorkoutRealmManager: ObservableObject, WorkOutRealmManagerProtocol {
    @ObservedResults(WorkOut.self) private var workOutLibrary

    private(set) var realm: Realm!

    init() {
        let config = Realm.Configuration(schemaVersion: 7)
        Realm.Configuration.defaultConfiguration = config
        do {
            self.realm = try Realm()
        } catch {
            print(error.localizedDescription)
        }
    }

    func add(_ value: WorkOut) {
        $workOutLibrary.append(value)
    }

    func load(primaryKey: String) -> WorkOut? {
        do {
            let objectId = try ObjectId(string: primaryKey)
            return workOutLibrary.first(where: { $0._id == objectId })

        } catch {
            print(error.localizedDescription)
            return nil
        }
    }

    func load() -> [WorkOut] {
        var objects: [WorkOut] = []
        let queue = DispatchQueue(label: "realmQueue", qos: .background)
        queue.sync {
            do {
                let realm = try Realm()
                objects = Array(realm.objects(WorkOut.self))
            } catch {
                print(error.localizedDescription)
            }
        }
        return objects
    }

    func delete(entity: WorkOut) {
        $workOutLibrary.remove(entity)
    }

    func update(_ id: ObjectId, _ name: String, _ work: Int, _ rest: Int, _ series: Int, _ rounds: Int, _ reset: Int) {
        do {
            try realm.write {
                let workout = realm.objects(WorkOut.self).first { $0._id == id }
                workout?.name = name
                workout?.work = work
                workout?.rest = rest
                workout?.series = series
                workout?.rounds = rounds
                workout?.reset = reset
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    func getSortedData(_ searchText: String, _ sortBy: WorkOutSortByProperty, _ sortOrder: SortOrder) -> [WorkOut] {
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