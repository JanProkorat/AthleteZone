//
//  AppContext.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 27.03.2024.
//

import Dependencies
import Foundation
import SwiftData

private let appContext: ModelContext = {
    do {
        let url = URL.applicationSupportDirectory.appending(path: "Model.sqlite")
        let config = ModelConfiguration(url: url)

        let container = try ModelContainer(for: Workout.self, Training.self, StopWatch.self, TimerActivity.self, configurations: config)
        return ModelContext(container)
    } catch {
        fatalError("Failed to create container.")
    }
}()

struct AppContext {
    var context: () throws -> ModelContext
}

extension AppContext: DependencyKey {
    public static let liveValue = Self(
        context: { appContext }
    )
}
