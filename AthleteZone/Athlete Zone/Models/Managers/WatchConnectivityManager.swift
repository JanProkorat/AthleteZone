//
//  WatchConnectivityManager.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 10.01.2023.
//

import ComposableArchitecture
import Foundation
import WatchConnectivity

final class WatchConnectivityManager: NSObject, ObservableObject, WatchConnectivityProtocol {
    var lastSentMessage: [String: Any]? // Not needed here, only for testing

    static let shared = WatchConnectivityManager()

    @Dependency(\.appStorageManager) var appStorageManager
    @Dependency(\.workoutRepository) var workoutRepository
    @Dependency(\.trainingRepository) var trainingRepository

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
            let replyData = loadReplyData()
            replyHandler(["data": replyData,
                          DefaultItem.language.rawValue: appStorageManager.getLanguage().rawValue,
                          DefaultItem.soundsEnabled.rawValue: appStorageManager.getSoundsEnabled(),
                          DefaultItem.hapticsEnabled.rawValue: appStorageManager.getHapticsEnabled()])
        }
    }

    func loadReplyData() -> String {
        do {
            let workouts = try workoutRepository.loadAll()
            let trainings = trainingRepository.loadAll()
            return WatchDataDto(workouts: workouts, trainings: trainings).toJSONString() ?? ""
        } catch {
            print(error.localizedDescription)
            return ""
        }
    }

    func sendValue(_ value: [String: Any]) {
        if checkIfPairedAppInstalled() {
            WCSession.default.sendMessage(value) { _ in }
        }
    }
}

extension WatchConnectivityManager: DependencyKey {
    static var liveValue: any WatchConnectivityProtocol = WatchConnectivityManager.shared
}
