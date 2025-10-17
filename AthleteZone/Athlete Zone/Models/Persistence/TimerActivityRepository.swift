//
//  TimerActivityRepository.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 28.03.2024.
//

import Dependencies
import Foundation
import SwiftData

struct TimerActivityRepository {
    var load: @Sendable () throws -> TimerDto?
    var add: @Sendable (_ interval: TimeInterval) throws -> Void
}

extension TimerActivityRepository: DependencyKey {
    static var liveValue = Self(
        load: {
            do {
                @Dependency(\.appContext.context) var context
                let dbContext = try context()
                let descriptor = FetchDescriptor<TimerActivity>(sortBy: [SortDescriptor<TimerActivity>(\.createdDate, order: .reverse)])
                return try dbContext.fetch(descriptor).first?.toDto()
            } catch {
                print(error.localizedDescription)
                return nil
            }
        },
        add: { interval in
            do {
                @Dependency(\.appContext.context) var context
                let dbContext = try context()

                var newActivity = TimerActivity(interval: interval)
                dbContext.insert(newActivity)

                let idToKeep = newActivity.id
                if try dbContext.fetchCount(FetchDescriptor<TimerActivity>()) > 1 {
                    try dbContext.delete(model: TimerActivity.self, where: #Predicate { $0.id != idToKeep })
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    )
}
