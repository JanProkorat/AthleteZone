//
//  RealmManagerProtocol.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 21.03.2023.
//

import Dependencies
import Foundation
import os
import SwiftData

struct WorkoutRepository {
    var add: @Sendable (_ workout: Workout) -> Void
    var load: @Sendable (_ primaryKey: String) -> WorkoutDto?
    var loadAll: @Sendable () -> [WorkoutDto]
    var delete: @Sendable (_ id: UUID) -> Void
    var isWorkoutAssignedToTraining: @Sendable (_ id: UUID) -> Bool

    var update: @Sendable (
        _ id: UUID,
        _ name: String,
        _ work: Int,
        _ rest: Int,
        _ series: Int,
        _ rounds: Int,
        _ reset: Int) -> Void

    var getSortedData: @Sendable (
        _ searchText: String,
        _ sortBy: WorkOutSortByProperty,
        _ sortOrder: SortOrder) -> [WorkoutDto]
}

extension WorkoutRepository: DependencyKey {
    private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: WorkoutRepository.self))

    static var liveValue = Self(
        add: { workout in
            do {
                @Dependency(\.appContext.context) var context
                let dbContext = try context()

                dbContext.insert(workout)
            } catch {
                logger.error("\(error.localizedDescription)")
            }
        },
        load: { primaryKey in
            do {
                @Dependency(\.appContext.context) var context
                let dbContext = try context()
                let id = UUID(uuidString: primaryKey) ?? UUID()
                let descriptor = FetchDescriptor<Workout>(predicate: #Predicate { $0.id == id })
                return try dbContext.fetch(descriptor).first?.toDto()
            } catch {
                logger.error("\(error.localizedDescription)")
                return nil
            }
        },
        loadAll: {
            do {
                @Dependency(\.appContext.context) var context
                let dbContext = try context()
                let descriptor = FetchDescriptor<Workout>(sortBy: [SortDescriptor(\.name)])
                return try dbContext.fetch(descriptor).map { $0.toDto() }
            } catch {
                logger.error("\(error.localizedDescription)")
                return []
            }
        },
        delete: { primaryKey in
            do {
                @Dependency(\.appContext.context) var context
                let dbContext = try context()
                let descriptor = FetchDescriptor<Workout>(predicate: #Predicate { $0.id == primaryKey })
                var itemToDelete = try dbContext.fetch(descriptor).first!
                dbContext.delete(itemToDelete)
            } catch {
                logger.error("\(error.localizedDescription)")
            }
        },
        isWorkoutAssignedToTraining: { id in
            do {
                @Dependency(\.appContext.context) var context
                let dbContext = try context()
                let descriptor = FetchDescriptor<Training>()
                let trainings = try dbContext.fetch(descriptor)
                return trainings.contains { training in
                    training.workouts.contains { workout in
                        workout.workoutId == id
                    }
                }
            } catch {
                logger.error("\(error.localizedDescription)")
                return false
            }
        },
        update: { id, name, work, rest, series, rounds, reset in
            do {
                @Dependency(\.appContext.context) var context
                let dbContext = try context()
                let descriptor = FetchDescriptor<Workout>(predicate: #Predicate { $0.id == id })
                if let itemToUpdate = try dbContext.fetch(descriptor).first {
                    itemToUpdate.name = name
                    itemToUpdate.work = work
                    itemToUpdate.rest = rest
                    itemToUpdate.series = series
                    itemToUpdate.rounds = rounds
                    itemToUpdate.reset = reset
                    dbContext.insert(itemToUpdate)
                }
            } catch {
                logger.error("\(error.localizedDescription)")
            }
        },
        getSortedData: { searchText, sortBy, sortOrder in
            do {
                @Dependency(\.appContext.context) var context
                let dbContext = try context()
                let sortDescriptor: SortDescriptor<Workout>
                switch sortBy {
                case .name:
                    sortDescriptor = SortDescriptor(\.name, order: sortOrder == .ascending ? .forward : .reverse)

                case .work:
                    sortDescriptor = SortDescriptor(\.work, order: sortOrder == .ascending ? .forward : .reverse)

                case .rest:
                    sortDescriptor = SortDescriptor(\.rest, order: sortOrder == .ascending ? .forward : .reverse)

                case .reset:
                    sortDescriptor = SortDescriptor(\.reset, order: sortOrder == .ascending ? .forward : .reverse)

                case .series:
                    sortDescriptor = SortDescriptor(\.series, order: sortOrder == .ascending ? .forward : .reverse)

                case .rounds:
                    sortDescriptor = SortDescriptor(\.rounds, order: sortOrder == .ascending ? .forward : .reverse)

                case .workoutLength:
                    sortDescriptor = SortDescriptor(\.workoutLength, order: sortOrder == .ascending ? .forward : .reverse)

                case .createdDate:
                    sortDescriptor = SortDescriptor(\.createdDate, order: sortOrder == .ascending ? .forward : .reverse)
                }
                let descriptor = searchText.isEmpty ? FetchDescriptor<Workout>(sortBy: [sortDescriptor]) :
                    FetchDescriptor<Workout>(predicate: #Predicate { $0.name.contains(searchText) }, sortBy: [sortDescriptor])

                return try dbContext.fetch(descriptor).map { $0.toDto() }
            } catch {
                logger.error("\(error.localizedDescription)")
                return []
            }
        })
}
