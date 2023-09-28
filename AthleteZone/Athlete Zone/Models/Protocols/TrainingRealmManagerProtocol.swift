//
//  TrainingRealmManagerProtocol.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 03.07.2023.
//

import Foundation
import RealmSwift

protocol TrainingRealmManagerProtocol {
    func load() -> [Training]
    func load(_ searchText: String, _ sortBy: TrainingSortByProperty, _ sortOrder: SortOrder) -> [Training]
    func load(primaryKey: String) -> Training?
    func delete(entity: Training)
    func add(_ training: Training)
    func update(_ id: ObjectId, _ name: String, _ description: String, _ workouts: [WorkOut])
}
