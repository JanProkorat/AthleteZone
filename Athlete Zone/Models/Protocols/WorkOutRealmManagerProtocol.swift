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
    func update(entity: WorkOut) -> WorkOut?
    func getSortedData(_ searchText: String, _ sortBy: WorkOutSortByProperty, _ sortOrder: SortOrder) -> [WorkOut]
}
