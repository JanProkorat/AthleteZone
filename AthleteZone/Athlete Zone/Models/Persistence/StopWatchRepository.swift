//
//  StopWatchRepository.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 28.03.2024.
//

import Dependencies
import Foundation
import SwiftData

struct StopWatchRepository {
    var add: @Sendable (_ value: StopWatch) throws -> Void
    var load: @Sendable (_ primaryKey: String) throws -> StopwatchDto?
    var loadAll: @Sendable () -> [StopwatchDto]
    var update: @Sendable (_ id: String, _ name: String) -> Void
    var delete: @Sendable (_ entityId: String) -> Void
    var loadLast: @Sendable () -> StopwatchDto?

    var getSortedData: @Sendable (
        _ searchText: String,
        _ sortBy: StopWatchSortByProperty,
        _ sortOrder: SortOrder) -> [StopwatchDto]
}

extension StopWatchRepository: DependencyKey {
    static var liveValue = Self(
        add: { activity in
            @Dependency(\.appContext.context) var context
            let dbContext = try context()
            dbContext.insert(activity)
        },
        load: { primaryKey in
            @Dependency(\.appContext.context) var context
            let dbContext = try context()
            if let entityId = UUID(uuidString: primaryKey) {
                let descriptor = FetchDescriptor<StopWatch>(predicate: #Predicate { $0.id == entityId })
                return try dbContext.fetch(descriptor).first?.toDto()
            }
            return nil
        },
        loadAll: {
            do {
                @Dependency(\.appContext.context) var context
                let dbContext = try context()
                let descriptor = FetchDescriptor<StopWatch>(sortBy: [SortDescriptor(\.startDate, order: .reverse)])
                return try dbContext.fetch(descriptor).map { $0.toDto() }
            } catch {
                print(error.localizedDescription)
                return []
            }
        },
        update: { id, name in
            do {
                @Dependency(\.appContext.context) var context
                let dbContext = try context()
                if let entityId = UUID(uuidString: id) {
                    let descriptor = FetchDescriptor<StopWatch>(predicate: #Predicate { $0.id == entityId })
                    var itemToUpdate = try dbContext.fetch(descriptor).first!
                    itemToUpdate.name = name
                }
            } catch {
                print(error.localizedDescription)
            }
        },
        delete: { primaryKey in
            do {
                @Dependency(\.appContext.context) var context
                let dbContext = try context()
                if let entityId = UUID(uuidString: primaryKey) {
                    let descriptor = FetchDescriptor<StopWatch>(predicate: #Predicate { $0.id == entityId })
                    let stopWatch = try dbContext.fetch(descriptor).first!
                    dbContext.delete(stopWatch)
                }
            } catch {
                print(error.localizedDescription)
            }
        },
        loadLast: {
            do {
                @Dependency(\.appContext.context) var context
                let dbContext = try context()
                let descriptor = SortDescriptor<StopWatch>(\.startDate, order: .reverse)
                return try dbContext.fetch(FetchDescriptor<StopWatch>(sortBy: [descriptor])).first?.toDto()
            } catch {
                print(error.localizedDescription)
                return nil
            }
        },
        getSortedData: { searchText, sortBy, sortOrder in
            do {
                @Dependency(\.appContext.context) var context
                let dbContext = try context()
                let sortDescriptor: SortDescriptor<StopWatch>
                switch sortBy {
                case .name:
                    sortDescriptor = SortDescriptor(\.name, order: sortOrder == .ascending ? .forward : .reverse)

                case .startDate:
                    sortDescriptor = SortDescriptor(\.startDate, order: sortOrder == .ascending ? .forward : .reverse)

                case .endDate:
                    sortDescriptor = SortDescriptor(\.endDate, order: sortOrder == .ascending ? .forward : .reverse)

                case .activityLength:
                    sortDescriptor = SortDescriptor(\.activityLength, order: sortOrder == .ascending ? .forward : .reverse)
                }
                let descriptor = searchText.isEmpty ? FetchDescriptor<StopWatch>(sortBy: [sortDescriptor]) :
                    FetchDescriptor<StopWatch>(predicate: #Predicate { $0.name.contains(searchText) }, sortBy: [sortDescriptor])

                return try dbContext.fetch(descriptor).map { $0.toDto() }
            } catch {
                print(error.localizedDescription)
                return []
            }
        })
}
