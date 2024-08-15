//
//  DependencyValues.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 08.05.2024.
//

import ComposableArchitecture
import Foundation

extension DependencyValues {
    var watchConnectivityManager: WatchConnectivityManager {
        get { self[WatchConnectivityManager.self] }
        set { self[WatchConnectivityManager.self] = newValue }
    }

    var appStorageManager: AppStorageManager {
        get { self[AppStorageManager.self] }
        set { self[AppStorageManager.self] = newValue }
    }

    var hapticManager: HapticManager {
        get { self[HapticManager.self] }
        set { self[HapticManager.self] = newValue }
    }

    var healthManager: HealthTrackingManager {
        get { self[HealthTrackingManager.self] }
        set { self[HealthTrackingManager.self] = newValue }
    }
}
