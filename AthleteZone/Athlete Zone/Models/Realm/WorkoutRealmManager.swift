//
//  RealmManager.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 24.11.2022.
//

import ComposableArchitecture
import Realm
import RealmSwift

class WorkoutRealmManager: RealmManager, WorkOutRealmProtocol {
    static let shared = WorkoutRealmManager()
    @ObservedResults(WorkOut.self) private var workOutLibrary

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

    func load() -> [WorkoutDto] {
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
        return objects.map { $0.toDto() }
    }

    func delete(entityId: String) {
        $workOutLibrary.remove(workOutLibrary.first(where: { $0.id == entityId })!)
    }

    func update(_ id: String, _ name: String, _ work: Int, _ rest: Int, _ series: Int, _ rounds: Int, _ reset: Int) {
        do {
            try realm.write {
                let workout = realm.objects(WorkOut.self).first { $0.id == id }
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

    func getSortedData(_ searchText: String, _ sortBy: WorkOutSortByProperty, _ sortOrder: SortOrder) -> [WorkoutDto] {
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
        return sortedWorkouts.map { $0.toDto() }
    }

    func isWorkoutAssignedToTraining(_ id: String) -> Bool {
        do {
            let workoutId = try ObjectId(string: id)
            return realm!.objects(Training.self).contains(where: {
                $0.workouts.contains {
                    $0._id == workoutId
                }
            })
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
}

extension WorkoutRealmManager: DependencyKey {
    static var liveValue: any WorkOutRealmProtocol = WorkoutRealmManager.shared
}
