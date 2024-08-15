//
//  HealthManager.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 02.09.2023.
//

import Dependencies
import Foundation
import HealthKit
import SwiftUI

class WatchHealthhManager: HealthManager {
    static let watchShared = WatchHealthhManager()

    @Published var averageHeartRate: Double = 0
    @Published var activeEnergy: Double = 0
    @Published var totalEnergy: Double = 0
    @Published var workout: HKWorkout?
    @Published var running = false

    var session: HKWorkoutSession?
    var builder: HKLiveWorkoutBuilder?
    private var startDate: Date?
    private var endDate: Date?

    var timeElapsed: TimeInterval {
        if startDate == nil || endDate == nil {
            return 0
        }
        return endDate!.timeIntervalSince(startDate!)
    }

    func startWorkout(workoutType: HKWorkoutActivityType, workoutName: String) async {
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = workoutType
        configuration.locationType = .unknown

        do {
            session = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
            builder = session?.associatedWorkoutBuilder()
        } catch {
            logger.error("""
            Creating HKWorkoutBuilder error: \(error.localizedDescription)
            """)
            return
        }

        builder?.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore, workoutConfiguration: configuration)

        let metadata = [
            HKMetadataKeyWorkoutBrandName: "\(workoutName)",
            HKMetadataKeyIndoorWorkout: NSNumber(value: true) as Any
        ]

        do {
            try await builder?.addMetadata(metadata)
        } catch {
            logger.error("""
            Error adding metadata: \(error.localizedDescription)
            """)
        }

        session?.delegate = self
        builder?.delegate = self

        // Start the workout session and begin data collection.
        startDate = Date()
        session?.startActivity(with: startDate!)
        do {
            try await builder?.beginCollection(at: startDate!)
            running = true
        } catch {
            logger.error("""
            Begin collection error: \(error.localizedDescription)
            """)
        }
    }

    // MARK: - State Control

    var paused: Bool {
        session?.state == .notStarted
    }

    private func pause() {
        session?.pause()
        running = false
    }

    private func resume() {
        session?.resume()
        running = true
    }

    func togglePuase() {
        if running == true {
            pause()
        } else {
            resume()
        }
    }

    func endWorkout() {
        endDate = Date()
        session?.end()
    }

    func resetWorkout() {
        builder = nil
        session = nil
        workout = nil
        activeEnergy = 0
        averageHeartRate = 0
        totalEnergy = 0
        running = false
        startDate = nil
        endDate = nil
    }

    private func setupAuthorizationObserver() {
        let authorizationQuery = HKObserverQuery(
            sampleType: HKQuantityType.workoutType(),
            predicate: nil
        ) { _, completionHandler, error in
            guard error == nil else {
                self.logger.error("Error observing authorization changes: \(error!.localizedDescription)")
                completionHandler()
                return
            }

            // Fetch the latest authorization status and update the hkAccessStatus
            let status = self.checkAuthorizationStatus()
            DispatchQueue.main.async {
                self.hkAccessStatus = status
            }

            // Call the completion handler to indicate that the query has been processed
            completionHandler()
        }

        // Execute the observer query
        healthStore.execute(authorizationQuery)
    }
}

// MARK: - HKWorkoutSessionDelegate

extension WatchHealthhManager: HKWorkoutSessionDelegate {
    func workoutSession(
        _ workoutSession: HKWorkoutSession,
        didChangeTo toState: HKWorkoutSessionState,
        from fromState: HKWorkoutSessionState,
        date: Date
    ) {
        DispatchQueue.main.async {
            self.running = toState == .running
        }
        // Wait for the session to transition states before ending the builder.
        if toState == .ended {
            builder?.endCollection(withEnd: date, completion: { _, _ in
                self.builder?.finishWorkout(completion: { workout, _ in
                    DispatchQueue.main.async {
                        self.workout = workout
                    }
                })
            })
        }
    }

    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {}
}

// MARK: - HKLiveWorkoutBuilderDelegate

extension WatchHealthhManager: HKLiveWorkoutBuilderDelegate {
    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {}

    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        for type in collectedTypes {
            guard let quantityType = type as? HKQuantityType else { return }
            let statistics = workoutBuilder.statistics(for: quantityType)

            // Update the published values.
            updateForStatistics(statistics)
        }
    }

    func updateForStatistics(_ statistics: HKStatistics?) {
        guard let statistics = statistics else {
            return
        }

        DispatchQueue.main.async {
            switch statistics.quantityType {
            case HKQuantityType.quantityType(forIdentifier: .heartRate):
                let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
                self.averageHeartRate = statistics.averageQuantity()?.doubleValue(for: heartRateUnit) ?? 0

            case HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned):
                let energyUnit = HKUnit.kilocalorie()
                self.activeEnergy = statistics.sumQuantity()?.doubleValue(for: energyUnit) ?? 0

            case HKQuantityType.quantityType(forIdentifier: .basalEnergyBurned):
                let energyUnit = HKUnit.kilocalorie()
                self.totalEnergy = statistics.sumQuantity()?.doubleValue(for: energyUnit) ?? 0 + self.activeEnergy

            default: return
            }
        }
    }
}

struct HealthTrackingManager {
    var checkAuthorizationStatus: @Sendable () -> HKAuthorizationStatus
    var requestAuthorization: @Sendable () -> Void
    var startWorkout: @Sendable (_ workoutType: HKWorkoutActivityType, _ workoutName: String) async -> Void
    var isPaused: @Sendable () -> Bool
    var isRunning: @Sendable () -> Bool
    var togglePuase: @Sendable () -> Void
    var endWorkout: @Sendable () -> Void
    var resetWorkout: @Sendable () -> Void
    var getAuthorizationStatus: @Sendable () -> HKAuthorizationStatus
    var getAverageHeartRate: @Sendable () -> Double
    var getActiveEnergy: @Sendable () -> Double
    var getTotalEnergy: @Sendable () -> Double
    var getWorkoutDuration: @Sendable () -> TimeInterval
}

extension HealthTrackingManager: DependencyKey {
    static var liveValue = Self(
        checkAuthorizationStatus: {
            WatchHealthhManager.watchShared.checkAuthorizationStatus()
        },
        requestAuthorization: {
            WatchHealthhManager.watchShared.requestAuthorization()
        },
        startWorkout: { type, name in
            await WatchHealthhManager.watchShared.startWorkout(workoutType: type, workoutName: name)
        },
        isPaused: {
            WatchHealthhManager.watchShared.paused
        },
        isRunning: {
            WatchHealthhManager.watchShared.running
        },
        togglePuase: {
            WatchHealthhManager.watchShared.togglePuase()
        },
        endWorkout: {
            WatchHealthhManager.watchShared.endWorkout()
        },
        resetWorkout: {
            WatchHealthhManager.watchShared.resetWorkout()
        },
        getAuthorizationStatus: {
            WatchHealthhManager.watchShared.hkAccessStatus
        },
        getAverageHeartRate: {
            WatchHealthhManager.watchShared.averageHeartRate
        },
        getActiveEnergy: {
            WatchHealthhManager.watchShared.activeEnergy
        },
        getTotalEnergy: {
            WatchHealthhManager.watchShared.totalEnergy
        },
        getWorkoutDuration: {
            WatchHealthhManager.watchShared.timeElapsed
        }
    )
}
