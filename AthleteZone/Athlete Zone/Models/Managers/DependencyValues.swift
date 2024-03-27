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

    var workoutRealmManager: WorkoutRealmManager {
        get { self[WorkoutRealmManager.self] }
        set { self[WorkoutRealmManager.self] = newValue }
    }

    var watchConnectivityManager: WatchConnectivityManager {
        get { self[WatchConnectivityManager.self] }
        set { self[WatchConnectivityManager.self] = newValue }
    }

    var soundManager: SoundManager {
        get { self[SoundManager.self] }
        set { self[SoundManager.self] = newValue }
    }

    var trainingRealmManager: TrainingRealmManager {
        get { self[TrainingRealmManager.self] }
        set { self[TrainingRealmManager.self] = newValue }
    }

    var stopWatchRealmManager: StopWatchRealmManager {
        get { self[StopWatchRealmManager.self] }
        set { self[StopWatchRealmManager.self] = newValue }
    }

    var timerRealmManager: TimerRealmManager {
        get { self[TimerRealmManager.self] }
        set { self[TimerRealmManager.self] = newValue }
    }

    var healthManager: HealthManager {
        get { self[HealthManager.self] }
        set { self[HealthManager.self] = newValue }
    }
}

extension HealthManager: DependencyKey {
    static var liveValue: HealthManager = .shared
}
