//
//  WatchConnectivityManager.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 10.01.2023.
//

import Foundation
import WatchConnectivity

final class WatchConnectivityManager: NSObject, ObservableObject, WatchConnectivityProtocol {
    var lastSentMessage: [String: Any]? // Not needed here, only for testing

    static let shared = WatchConnectivityManager()

    var appStorageManager = AppStorageManager.shared

    @Published var isSessionReachable = false
    @Published var isPairedAppInstalled = false

    @Published var receivedData: String?
    @Published var receivedNewWorkout: String?
    @Published var receivedNewTraining: String?
    @Published var receivedUpdateWorkout: String?
    @Published var receivedUpdateTraining: String?
    @Published var receivedRemoveWorkout: String?
    @Published var receivedRemoveTraining: String?

    override private init() {
        super.init()

        #if !os(watchOS)
        guard WCSession.isSupported() else {
            print("Not supported")
            return
        }
        #endif

        WCSession.default.delegate = self
        WCSession.default.activate()
    }
}

// MARK: - Is paired app installed

// TODO: - Integrate to settings
extension WatchConnectivityManager {
    func checkIfPairedAppInstalled() {
        #if os(watchOS)
        guard WCSession.default.isCompanionAppInstalled else {
            print("iOS app not installed on the paired Apple Watch")
            return
        }
        #else
        guard WCSession.default.isWatchAppInstalled else {
            print("WatchOS app not installed on the paired Apple Watch")
            return
        }
        #endif

        self.isPairedAppInstalled.toggle()
    }
}

// MARK: - WCSessionDelegate

extension WatchConnectivityManager: WCSessionDelegate {
    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {}

    func sessionDidDeactivate(_ session: WCSession) {
        WCSession.default.activate()
    }
    #endif

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        switch activationState {
        case .activated:
            print("Activated")

        case .notActivated:
            print("Not Activated")

        case .inactive:
            print("Inactive")
        @unknown default:
            break
        }
    }

    func session(_ session: WCSession, didReceiveMessage message: [String: Any], replyHandler: @escaping ([String: Any]) -> Void) {
        if message["data"] != nil {
            let replyData = self.loadReplyData()
            replyHandler(["data": replyData,
                          DefaultItem.language.rawValue: self.appStorageManager.language.rawValue,
                          DefaultItem.soundsEnabled.rawValue: self.appStorageManager.soundsEnabled,
                          DefaultItem.hapticsEnabled.rawValue: self.appStorageManager.hapticsEnabled])
        }

        DispatchQueue.main.async {
            self.decodeMessage(message)
        }
    }

    public func requestData() {
        guard WCSession.default.activationState == .activated else {
            print("Session not in active state")
            return
        }

        #if os(watchOS)
        guard WCSession.default.isCompanionAppInstalled else {
            print("iOS app not installed")
            return
        }
        #else
        guard WCSession.default.isWatchAppInstalled else {
            print("WatchOS app not installed")
            return
        }
        #endif

        WCSession.default.sendMessage(["data": "data"]) { newValue in
            DispatchQueue.main.async {
                self.decodeMessage(newValue)
            }

        } errorHandler: { error in
            print(["Error sending data request", error.localizedDescription])
        }
    }

    func loadReplyData() -> String {
        #if os(iOS)
        let workoutManager = WorkoutRealmManager()
        let workouts = workoutManager.load().map { $0.toDto() }

        let trainingManager = TrainingRealmManager()
        let trainings = trainingManager.load().map { $0.toDto() }
        return WatchDataDto(workouts: workouts, trainings: trainings).toJSONString() ?? ""
        #else
        return ""
        #endif
    }

    func sessionReachabilityDidChange(_ session: WCSession) {
        self.isSessionReachable = session.isReachable
    }

    func sendValue(_ value: [String: Any]) {
        WCSession.default.sendMessage(value) { _ in }
    }

    func decodeMessage(_ message: [String: Any]) {
        if let dataString = message["data"] as? String {
            self.receivedData = dataString
        }
        if let language = message[DefaultItem.language.rawValue] as? String {
            self.appStorageManager.language = Language(rawValue: language) ?? .en
        }
        if let sounds = message[DefaultItem.soundsEnabled.rawValue] as? Bool {
            self.appStorageManager.soundsEnabled = sounds
        }
        if let haptics = message[DefaultItem.hapticsEnabled.rawValue] as? Bool {
            self.appStorageManager.hapticsEnabled = haptics
        }
        if let workout = message["workout_add"] as? String {
            self.receivedNewWorkout = workout
        }
        if let workout = message["workout_edit"] as? String {
            self.receivedUpdateWorkout = workout
        }
        if let workoutId = message["workout_remove"] as? String {
            self.receivedRemoveWorkout = workoutId
        }
        if let trainingId = message["training_remove"] as? String {
            self.receivedRemoveTraining = trainingId
        }
        if let training = message["training_edit"] as? String {
            self.receivedUpdateTraining = training
        }
        if let training = message["training_add"] as? String {
            self.receivedNewTraining = training
        }
    }
}
