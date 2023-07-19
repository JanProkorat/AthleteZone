//
//  RealmManagerProtocol.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 21.03.2023.
//

import Foundation
import RealmSwift

protocol WorkOutRealmManagerProtocol {
    func add(_ value: WorkOut)
    func load(primaryKey: String) -> WorkOut?
    func load() -> [WorkOut]
    func delete(entity: WorkOut)
    func update(_ id: ObjectId, _ name: String, _ work: Int, _ rest: Int, _ series: Int, _ rounds: Int, _ reset: Int)
    func getSortedData(_ searchText: String, _ sortBy: WorkOutSortByProperty, _ sortOrder: SortOrder) -> [WorkOut]
}
