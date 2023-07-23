//
//  TrainingRealmManager.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 03.07.2023.
//

import Foundation
import RealmSwift

class TrainingRealmManager: ObservableObject, TrainingRealmManagerProtocol {
    @ObservedResults(Training.self) private var trainingLibrary

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

    func load(_ searchText: String, _ sortBy: TrainingSortByProperty, _ sortOrder: SortOrder) -> [Training] {
        // Step 1: Filter the list of trainings based on the search text (name).
        let filteredTrainings: [Training]
        if searchText.isEmpty {
            // If the search text is empty, return all trainings without filtering.
            filteredTrainings = Array(trainingLibrary)
        } else {
            // Otherwise, filter based on the search text.
            filteredTrainings = trainingLibrary.filter { training in
                training.name.lowercased().contains(searchText.lowercased())
            }
        }

        // Step 2: Sort the filtered list based on the selected `sortBy` and `sortOrder`.
        let sortedTrainings: [Training]
        switch sortBy {
        case .name:
            sortedTrainings = filteredTrainings.sorted { training1, training2 in
                sortOrder == .ascending ?
                training1.name < training2.name :
                training1.name > training2.name
            }
        case .createdDate:
            sortedTrainings = filteredTrainings.sorted { training1, training2 in
                sortOrder == .ascending ?
                training1.createdDate < training2.createdDate :
                training1.createdDate > training2.createdDate
            }
        case .numOfWorkouts:
            sortedTrainings = filteredTrainings.sorted { training1, training2 in
                sortOrder == .ascending ?
                training1.workoutCount < training2.workoutCount :
                training1.workoutCount > training2.workoutCount
            }
        case .trainingLength:
            sortedTrainings = filteredTrainings.sorted { training1, training2 in
                sortOrder == .ascending ?
                training1.trainingLength < training2.trainingLength :
                training1.trainingLength > training2.trainingLength
            }
        }

        // Step 3: Return the sorted and filtered list as an array.
        return sortedTrainings
    }

    func delete(entity: Training) {
        $trainingLibrary.remove(entity)
    }

    func load(primaryKey: String) -> Training? {
        do {
            let objectId = try ObjectId(string: primaryKey)
            return trainingLibrary.first(where: { $0._id == objectId })

        } catch {
            print(error.localizedDescription)
            return nil
        }
    }

    func add(_ training: Training) {
        $trainingLibrary.append(training)
    }

    func update(_ id: ObjectId, _ name: String, _ description: String, _ workouts: [WorkOut]) {
        do {
            try realm.write {
                let training = realm.objects(Training.self).first { $0._id == id }
                training?.name = name
                training?.trainingDescription = description
                training?.workouts.removeAll()
                training?.workouts.append(objectsIn: workouts)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
