//
//  TrainingRepository.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 28.03.2024.
//

import Dependencies
import Foundation
import SwiftData

struct TrainingRepository {
    var add: @Sendable (_ training: Training) throws -> Void
    var load: @Sendable (_ primaryKey: String) -> TrainingDto?
    var loadAll: @Sendable () -> [TrainingDto]
    var delete: @Sendable (_ entityId: String) throws -> Void

    var update: @Sendable (
        _ id: String,
        _ name: String,
        _ description: String,
        _ workouts: [WorkoutInfo]) throws -> Void

    var getSortedData: @Sendable (
        _ searchText: String,
        _ sortBy: TrainingSortByProperty,
        _ sortOrder: SortOrder) -> [TrainingDto]
}

extension TrainingRepository: DependencyKey {
    static var liveValue = Self(
        add: { training in
            do {
                @Dependency(\.appContext.context) var context
                let dbContext = try context()
                dbContext.insert(training)
            } catch {
                print(error.localizedDescription)
            }
        },
        load: { primaryKey in
            do {
                @Dependency(\.appContext.context) var context
                let dbContext = try context()
                if let entityId = UUID(uuidString: primaryKey) {
                    let descriptor = FetchDescriptor<Training>(predicate: #Predicate { $0.id == entityId })
                    var training = try dbContext.fetch(descriptor).first
                    var dto = training?.toDto()
                    try training?.workouts.forEach { info in
                        let workoutDescriptor = FetchDescriptor<Workout>(predicate: #Predicate { $0.id == info.id })
                        if let workout = try dbContext.fetch(workoutDescriptor).first {
                            dto?.workouts.append(workout.toDto())
                        }
                    }
                    return dto
                }
                return nil
            } catch {
                print(error.localizedDescription)
                return nil
            }
        },
        loadAll: {
            do {
                @Dependency(\.appContext.context) var context
                let dbContext = try context()
                let descriptor = FetchDescriptor<Training>(sortBy: [SortDescriptor(\.name)])
                var trainings = try dbContext.fetch(descriptor)
                return try trainings.map { item in
                    var dto = item.toDto()
                    let workoutIds = item.workouts.map { $0.id }
                    var workoutDescriptor = FetchDescriptor<Workout>(predicate: #Predicate { workout in
                        workoutIds.contains(workout.id)
                    })
                    dto.workouts = try dbContext.fetch(workoutDescriptor).map { $0.toDto() }
                    return dto
                }
            } catch {
                print(error.localizedDescription)
                return []
            }
        },
        delete: { primaryKey in
            do {
                @Dependency(\.appContext.context) var context
                let dbContext = try context()
                if let entityId = UUID(uuidString: primaryKey) {
                    let descriptor = FetchDescriptor<Training>(predicate: #Predicate { $0.id == entityId })
                    let training = try dbContext.fetch(descriptor).first!
                    dbContext.delete(training)
                }
            } catch {
                print(error.localizedDescription)
            }
        },
        update: { id, name, description, workouts in
            do {
                @Dependency(\.appContext.context) var context
                let dbContext = try context()
                if let entityId = UUID(uuidString: id) {
                    let descriptor = FetchDescriptor<Training>(predicate: #Predicate { $0.id == entityId })
                    var itemToUpdate = try dbContext.fetch(descriptor).first!
                    itemToUpdate.name = name
                    itemToUpdate.trainingDescription = description
                    itemToUpdate.workouts = workouts
                }
            } catch {
                print(error.localizedDescription)
            }
        },
        getSortedData: { searchText, sortBy, sortOrder in
            do {
                @Dependency(\.appContext.context) var context
                let dbContext = try context()
                let sortDescriptor: SortDescriptor<Training>
                switch sortBy {
                case .name:
                    sortDescriptor = SortDescriptor(\.name, order: sortOrder == .ascending ? .forward : .reverse)

                case .createdDate:
                    sortDescriptor = SortDescriptor(\.createdDate, order: sortOrder == .ascending ? .forward : .reverse)

                case .trainingLength:
                    sortDescriptor = SortDescriptor(\.trainingLength, order: sortOrder == .ascending ? .forward : .reverse)

                case .numOfWorkouts:
                    sortDescriptor = SortDescriptor(\.workoutCount, order: sortOrder == .ascending ? .forward : .reverse)
                }
                let descriptor = searchText.isEmpty ? FetchDescriptor<Training>(sortBy: [sortDescriptor]) :
                    FetchDescriptor<Training>(predicate: #Predicate { $0.name.contains(searchText) }, sortBy: [sortDescriptor])

                var trainings = try dbContext.fetch(descriptor)
                return try trainings.map { item in
                    var dto = item.toDto()
                    try item.workouts.forEach { info in
                        var workoutDescriptor = FetchDescriptor<Workout>(predicate: #Predicate { $0.id == info.id })
                        if let workout = try dbContext.fetch(workoutDescriptor).first {
                            dto.workouts.append(workout.toDto())
                        }
                    }
                    return dto
                }
            } catch {
                print(error.localizedDescription)
                return []
            }
        })

    static var testValue = liveValue
}
