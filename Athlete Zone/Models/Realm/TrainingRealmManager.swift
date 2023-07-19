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
        var trainingResults: Results<Training>

        if !searchText.isEmpty {
            trainingResults = trainingLibrary.filter("name CONTAINS[c] %@", searchText)
        } else {
            trainingResults = trainingLibrary
        }

        var sortedResults: [Training]

        switch sortBy {
        case .name:
            sortedResults = Array(trainingResults.sorted(byKeyPath: "name", ascending: sortOrder == .ascending))

        case .createdDate:
            sortedResults = Array(trainingResults.sorted(byKeyPath: "createdDate", ascending: sortOrder == .ascending))

        default:
            sortedResults = Array(trainingResults)
        }

        switch sortBy {
        case .numOfWorkouts:
            sortedResults.sort { $0.workoutCount < $1.workoutCount }

        case .trainingLength:
            sortedResults.sort { $0.trainingLength < $1.trainingLength }

        default:
            break
        }

        realm.refresh()

        return sortedResults
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
