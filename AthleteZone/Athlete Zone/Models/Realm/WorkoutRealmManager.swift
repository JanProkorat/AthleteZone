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
        // Step 1: Filter the list of workouts based on the search text (name).
        let filteredWorkouts: [WorkOut]
        if searchText.isEmpty {
            // If the search text is empty, return all workouts without filtering.
            filteredWorkouts = Array(workOutLibrary)
        } else {
            // Otherwise, filter based on the search text.
            filteredWorkouts = workOutLibrary.filter { workout in
                workout.name.lowercased().contains(searchText.lowercased())
            }
        }

        // Step 2: Sort the filtered list based on the selected `sortBy` and `sortOrder`.
        let sortedWorkouts: [WorkOut]
        switch sortBy {
        case .name:
            sortedWorkouts = filteredWorkouts.sorted { workout1, workout2 in
                sortOrder == .ascending ?
                    workout1.name < workout2.name :
                    workout1.name > workout2.name
            }

        case .work:
            sortedWorkouts = filteredWorkouts.sorted { workout1, workout2 in
                sortOrder == .ascending ?
                    workout1.work < workout2.work :
                    workout1.work > workout2.work
            }

        case .rest:
            sortedWorkouts = filteredWorkouts.sorted { workout1, workout2 in
                sortOrder == .ascending ?
                    workout1.rest < workout2.rest :
                    workout1.rest > workout2.rest
            }

        case .series:
            sortedWorkouts = filteredWorkouts.sorted { workout1, workout2 in
                sortOrder == .ascending ?
                    workout1.series < workout2.series :
                    workout1.series > workout2.series
            }

        case .rounds:
            sortedWorkouts = filteredWorkouts.sorted { workout1, workout2 in
                sortOrder == .ascending ?
                    workout1.rounds < workout2.rounds :
                    workout1.rounds > workout2.rounds
            }

        case .reset:
            sortedWorkouts = filteredWorkouts.sorted { workout1, workout2 in
                sortOrder == .ascending ?
                    workout1.reset < workout2.reset :
                    workout1.reset > workout2.reset
            }

        case .createdDate:
            sortedWorkouts = filteredWorkouts.sorted { workout1, workout2 in
                sortOrder == .ascending ?
                    workout1.createdDate < workout2.createdDate :
                    workout1.createdDate > workout2.createdDate
            }

        case .workoutLength:
            sortedWorkouts = filteredWorkouts.sorted { workout1, workout2 in
                sortOrder == .ascending ?
                    workout1.workoutLength < workout2.workoutLength :
                    workout1.workoutLength > workout2.workoutLength
            }
        }

        // Step 3: Return the sorted and filtered list as an array.
        return sortedWorkouts
    }
}
