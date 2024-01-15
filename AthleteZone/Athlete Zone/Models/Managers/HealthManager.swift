//
//  HealthManager.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 03.09.2023.
//

// import Combine
// import Foundation
// import HealthKit
//
// class HealthManager: NSObject, HealthProtocol {
//    static let shared = HealthManager()
//
//    public let healthStore = HKHealthStore()
//    public let typesToRead: Set = [
//        HKQuantityType.quantityType(forIdentifier: .heartRate)!,
//        HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
//        HKQuantityType.quantityType(forIdentifier: .basalEnergyBurned)!,
//        HKObjectType.activitySummaryType()
//    ]
//    public let typesToShare: Set = [
//        HKQuantityType.workoutType()
//    ]
//
//    private var authorizationObserver: HKObserverQuery?
//
//    @Published var hkAccessStatus: HKAuthorizationStatus = .notDetermined
//
//    override init() {
//        super.init()
//        hkAccessStatus = checkAuthorizationStatus()
//    }
//
//    func requestAuthorization() {
//        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { _, error in
//            if let newError = error {
//                print(["Workout request authorization error", newError.localizedDescription])
//            } else {
//                self.setupAuthorizationObserver()
//            }
//        }
//    }
//
//    func checkAuthorizationStatus() -> HKAuthorizationStatus {
//        let workoutType = HKQuantityType.workoutType()
//        return healthStore.authorizationStatus(for: workoutType)
//    }
//
//    private func setupAuthorizationObserver() {
//        let authorizationQuery = HKObserverQuery(
//            sampleType: typesToShare.first!,
//            predicate: nil
//        ) { _, completionHandler, error in
//
//            if let error = error {
//                print("Error observing authorization changes: \(error.localizedDescription)")
//                completionHandler()
//                return
//            }
//
//            let status = self.checkAuthorizationStatus()
//            if status != self.hkAccessStatus {
//                DispatchQueue.main.async {
//                    self.hkAccessStatus = status
//                }
//            }
//
//            completionHandler()
//        }
//
//        healthStore.execute(authorizationQuery)
//        authorizationObserver = authorizationQuery
//    }
// }
