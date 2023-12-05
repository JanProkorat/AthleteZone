//
//  TimerRealmManagerProtocol.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 30.11.2023.
//

import Foundation

protocol StopWatchRealmManagerProtocol {
    func add(_ value: StopWatch)
    func load(primaryKey: String) -> StopWatch?
    func load() -> [StopWatch]
    func delete(entity: StopWatch)
    func getSortedData(_ searchText: String, _ sortBy: StopWatchSortByProperty, _ sortOrder: SortOrder) -> [StopWatch]
    func update(_ id: String, _ name: String)
    func delete(at: IndexSet)
}
