//
//  DependencyValues.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 20.03.2024.
//

import ComposableArchitecture
import Foundation

extension DependencyValues {
    var appStorageManager: AppStorageManager {
        get { self[AppStorageManager.self] }
        set { self[AppStorageManager.self] = newValue }
    }

    var notificationManager: NotificationManager {
        get { self[NotificationManager.self] }
        set { self[NotificationManager.self] = newValue }
    }

    var subscriptionManager: SubscriptionManager {
        get { self[SubscriptionManager.self] }
        set { self[SubscriptionManager.self] = newValue }
    }

    var workoutRepository: WorkoutRepository {
        get { self[WorkoutRepository.self] }
        set { self[WorkoutRepository.self] = newValue }
    }

    var watchConnectivityManager: WatchConnectivityManager {
        get { self[WatchConnectivityManager.self] }
        set { self[WatchConnectivityManager.self] = newValue }
    }

    var soundManager: SoundManager {
        get { self[SoundManager.self] }
        set { self[SoundManager.self] = newValue }
    }

    var trainingRepository: TrainingRepository {
        get { self[TrainingRepository.self] }
        set { self[TrainingRepository.self] = newValue }
    }

    var stopWatchRepository: StopWatchRepository {
        get { self[StopWatchRepository.self] }
        set { self[StopWatchRepository.self] = newValue }
    }

    var timerActivityRepository: TimerActivityRepository {
        get { self[TimerActivityRepository.self] }
        set { self[TimerActivityRepository.self] = newValue }
    }

    var healthManager: HealthManager {
        get { self[HealthManager.self] }
        set { self[HealthManager.self] = newValue }
    }

    var appContext: AppContext {
        get { self[AppContext.self] }
        set { self[AppContext.self] = newValue }
    }
}

extension HealthManager: DependencyKey {
    static var liveValue: HealthManager = .shared
}
