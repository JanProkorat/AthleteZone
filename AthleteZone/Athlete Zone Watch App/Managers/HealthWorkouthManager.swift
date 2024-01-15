//
//  HealthManager.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 02.09.2023.
//
//
// import Foundation
// import HealthKit
//
// class HealthWorkouthManager: HealthManager {
//    @Published var averageHeartRate: Double = 0
//    @Published var activeEnergy: Double = 0
//    @Published var baseEnergy: Double = 0
//    @Published var workout: HKWorkout?
//    @Published var running = false
//
//    var session: HKWorkoutSession?
//    var builder: HKLiveWorkoutBuilder?
//
//    func startWorkout(workoutType: HKWorkoutActivityType, workoutName: String) {
//        let configuration = HKWorkoutConfiguration()
//        configuration.activityType = workoutType
//        configuration.locationType = .unknown
//
//        do {
//            session = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
//            builder = session?.associatedWorkoutBuilder()
//        } catch {
//            print(["Creating HKWorkoutBuilder error", error.localizedDescription])
//            return
//        }
//
//        builder?.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore, workoutConfiguration: configuration)
//
//        let metadata = [
//            HKMetadataKeyWorkoutBrandName: workoutName as Any,
//            HKMetadataKeyIndoorWorkout: NSNumber(value: true) as Any
//        ]
//
//        builder?.addMetadata(metadata, completion: { _, error in
//            if let locError = error {
//                print(["Error adding metadata: ", locError.localizedDescription])
//            }
//        })
//
//        session?.delegate = self
//        builder?.delegate = self
//
//        // Start the workout session and begin data collection.
//        let workoutStartDate = Date()
//        session?.startActivity(with: workoutStartDate)
//        builder?.beginCollection(withStart: workoutStartDate, completion: { _, error in
//            if let newError = error {
//                print(["Begin collection error", newError.localizedDescription])
//            }
//        })
//        running = true
//    }
//
//    // MARK: - State Control
//
//    var paused: Bool {
//        session?.state == .paused
//    }
//
//    func pause() {
//        session?.pause()
//    }
//
//    func resume() {
//        session?.resume()
//    }
//
//    func togglePuase() {
//        if running == true {
//            pause()
//        } else {
//            resume()
//        }
//    }
//
//    func endWorkout() {
//        session?.end()
//        resetWorkout()
//    }
//
//    func resetWorkout() {
//        builder = nil
//        session = nil
//        workout = nil
//        activeEnergy = 0
//        averageHeartRate = 0
//        baseEnergy = 0
//    }
// }
//
//// MARK: - HKWorkoutSessionDelegate
//
// extension HealthWorkouthManager: HKWorkoutSessionDelegate {
//    func workoutSession(
//        _ workoutSession: HKWorkoutSession,
//        didChangeTo toState: HKWorkoutSessionState,
//        from fromState: HKWorkoutSessionState,
//        date: Date
//    ) {
//        DispatchQueue.main.async {
//            self.running = toState == .running
//        }
//        // Wait for the session to transition states before ending the builder.
//        if toState == .ended {
//            builder?.endCollection(withEnd: date, completion: { _, _ in
//                self.builder?.finishWorkout(completion: { workout, _ in
//                    DispatchQueue.main.async {
//                        self.workout = workout
//                    }
//                })
//            })
//        }
//    }
//
//    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {}
// }
//
//// MARK: - HKLiveWorkoutBuilderDelegate
//
// extension HealthWorkouthManager: HKLiveWorkoutBuilderDelegate {
//    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {}
//
//    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
//        for type in collectedTypes {
//            guard let quantityType = type as? HKQuantityType else { return }
//            let statistics = workoutBuilder.statistics(for: quantityType)
//
//            // Update the published values.
//            updateForStatistics(statistics)
//        }
//    }
//
//    func updateForStatistics(_ statistics: HKStatistics?) {
//        guard let statistics = statistics else {
//            return
//        }
//
//        DispatchQueue.main.async {
//            switch statistics.quantityType {
//            case HKQuantityType.quantityType(forIdentifier: .heartRate):
//                let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
//                self.averageHeartRate = statistics.averageQuantity()?.doubleValue(for: heartRateUnit) ?? 0
//
//            case HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned):
//                let energyUnit = HKUnit.kilocalorie()
//                self.activeEnergy = statistics.sumQuantity()?.doubleValue(for: energyUnit) ?? 0
//
//            case HKQuantityType.quantityType(forIdentifier: .basalEnergyBurned),
//                 HKQuantityType.quantityType(forIdentifier: .basalEnergyBurned):
//                let energyUnit = HKUnit.kilocalorie()
//                self.baseEnergy = statistics.sumQuantity()?.doubleValue(for: energyUnit) ?? 0
//
//            default: return
//            }
//        }
//    }
// }
