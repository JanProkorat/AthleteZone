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

    override private init() {
        super.init()

        guard WCSession.isSupported() else {
            print("WCSession Not supported")
            return
        }

        WCSession.default.delegate = self
        WCSession.default.activate()
    }
}

// MARK: - Is paired app installed

extension WatchConnectivityManager {
    func checkIfPairedAppInstalled() -> Bool {
        return WCSession.default.isWatchAppInstalled
    }
}

// MARK: - WCSessionDelegate

extension WatchConnectivityManager: WCSessionDelegate {
    func sessionDidBecomeInactive(_ session: WCSession) {}

    func sessionDidDeactivate(_ session: WCSession) {
        WCSession.default.activate()
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        switch activationState {
        case .activated:
            print("Phone Activated")

        case .notActivated:
            print("Phone Not Activated")

        case .inactive:
            print("Phone Inactive")
        @unknown default:
            break
        }
    }

    ///  Receives message from watch when watch app is starting, loads all necessary data and sends back a reply
    /// - Parameters:
    ///   - session: Watch connectivity session
    ///   - message: Message received from watch
    ///   - replyHandler: Handler to send back a reply
    func session(_ session: WCSession, didReceiveMessage message: [String: Any], replyHandler: @escaping ([String: Any]) -> Void) {
        if message["data"] != nil {
            let replyData = self.loadReplyData()
            replyHandler(["data": replyData,
                          DefaultItem.language.rawValue: self.appStorageManager.language.rawValue,
                          DefaultItem.soundsEnabled.rawValue: self.appStorageManager.soundsEnabled,
                          DefaultItem.hapticsEnabled.rawValue: self.appStorageManager.hapticsEnabled])
        }
    }

    func loadReplyData() -> String {
        let workoutManager = WorkoutRealmManager()
        let workouts = workoutManager.load().map { $0.toDto() }

        let trainingManager = TrainingRealmManager()
        let trainings = trainingManager.load().map { $0.toDto() }
        return WatchDataDto(workouts: workouts, trainings: trainings).toJSONString() ?? ""
    }

    func sendValue(_ value: [String: Any]) {
        WCSession.default.sendMessage(value) { _ in }
    }
}
