//
//  RealmManagerProtocol.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 21.03.2023.
//

import Foundation
import RealmSwift

protocol WorkOutRealmProtocol {
    func add(_ value: WorkOut)
    func load(primaryKey: String) -> WorkOut?
    func load() -> [WorkoutDto]
    func delete(entityId: String)
    func update(_ id: String, _ name: String, _ work: Int, _ rest: Int, _ series: Int, _ rounds: Int, _ reset: Int)
    func getSortedData(_ searchText: String, _ sortBy: WorkOutSortByProperty, _ sortOrder: SortOrder) -> [WorkoutDto]
    func isWorkoutAssignedToTraining(_ id: String) -> Bool
}
