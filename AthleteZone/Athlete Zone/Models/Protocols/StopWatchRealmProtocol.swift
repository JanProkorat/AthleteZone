//
//  TimerRealmManagerProtocol.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 30.11.2023.
//

import Foundation

protocol StopWatchRealmProtocol {
    func add(_ value: StopWatch)
    func load(primaryKey: String) -> StopWatch?
    func load() -> [StopWatch]
    func getSortedData(_ searchText: String, _ sortBy: StopWatchSortByProperty, _ sortOrder: SortOrder) -> [StopwatchDto]
    func update(_ id: String, _ name: String)
    func delete(entityId: String)
    func loadLast() -> StopwatchDto?
}
