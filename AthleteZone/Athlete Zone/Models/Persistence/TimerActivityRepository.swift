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
    var load: @Sendable () throws -> [TimerDto]
    var add: @Sendable (_ interval: TimeInterval) throws -> Void
}

extension TimerActivityRepository: DependencyKey {
    static var liveValue = Self(
        load: {
            do {
                @Dependency(\.appContext.context) var context
                let dbContext = try context()
                let descriptor = FetchDescriptor<TimerActivity>(sortBy: [SortDescriptor<TimerActivity>(\.createdDate, order: .reverse)])
                return try dbContext.fetch(descriptor).map { $0.toDto() }
            } catch {
                print(error.localizedDescription)
                return []
            }
        },
        add: { interval in
            do {
                @Dependency(\.appContext.context) var context
                let dbContext = try context()

                dbContext.insert(TimerActivity(interval: interval))

                if try dbContext.fetchCount(FetchDescriptor<TimerActivity>()) > 5 {
                    let descriptor = FetchDescriptor<TimerActivity>(
                        sortBy: [SortDescriptor<TimerActivity>(\.createdDate, order: .forward)])
                    let itemToDelete = try dbContext.fetch(descriptor).first!
                    dbContext.delete(itemToDelete)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    )
}
