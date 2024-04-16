//
//  AppContextMock.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 13.04.2024.
//

import Foundation
import SwiftData

struct AppContextMock {
    static let InMemoryContext: ModelContext = {
        do {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)

            let container = try ModelContainer(for: Workout.self, Training.self, StopWatch.self, TimerActivity.self, configurations: config)
            return ModelContext(container)
        } catch {
            fatalError("Failed to create container.")
        }
    }()

    var context: () throws -> ModelContext
}
