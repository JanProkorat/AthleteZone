//
//  TrainingRealmManagerProtocol.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 03.07.2023.
//

import Foundation
import RealmSwift

protocol TrainingRealmProtocol {
    func load() -> [Training]
    func load(_ searchText: String, _ sortBy: TrainingSortByProperty, _ sortOrder: SortOrder) -> [TrainingDto]
    func load(primaryKey: String) -> TrainingDto?
    func delete(entityId: String)
    func add(_ training: Training)
    func update(_ id: String, _ name: String, _ description: String, _ workouts: [WorkOut])
}
