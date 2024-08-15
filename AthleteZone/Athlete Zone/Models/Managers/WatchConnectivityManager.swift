//
//  WatchConnectivityManager.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 10.01.2023.
//

import ComposableArchitecture
import Foundation
import os
import WatchConnectivity

final class ConnectivityManager: NSObject, ObservableObject {
    static let shared = ConnectivityManager()
    static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: ConnectivityManager.self)
    )
    @Dependency(\.appStorageManager) var appStorageManager
    @Dependency(\.workoutRepository) var workoutRepository
    @Dependency(\.trainingRepository) var trainingRepository

    override private init() {
        super.init()

        guard WCSession.isSupported() else {
            ConnectivityManager.logger.info("WCSession Not supported")
            return
        }

        WCSession.default.delegate = self
        WCSession.default.activate()
    }
}

// MARK: - Is paired app installed

extension ConnectivityManager {
    func checkIfPairedAppInstalled() -> Bool {
        return WCSession.default.isWatchAppInstalled
    }
}

// MARK: - WCSessionDelegate

extension ConnectivityManager: WCSessionDelegate {
    func sessionDidBecomeInactive(_ session: WCSession) {}

    func sessionDidDeactivate(_ session: WCSession) {
        WCSession.default.activate()
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        switch activationState {
        case .activated:
            ConnectivityManager.logger.info("Phone Activated")

        case .notActivated:
            ConnectivityManager.logger.info("Phone Not Activated")

        case .inactive:
            ConnectivityManager.logger.info("Phone Inactive")

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
        if message[DefaultItem.initData.rawValue] != nil {
            let replyData = loadReplyData()
            replyHandler([DefaultItem.initData.rawValue: replyData,
                          DefaultItem.language.rawValue: appStorageManager.getLanguage().rawValue,
                          DefaultItem.hapticsEnabled.rawValue: appStorageManager.getHapticsEnabled()])
        }
    }

    func loadReplyData() -> String {
        let workouts = workoutRepository.loadAll()
        let trainings = trainingRepository.loadAll()
        return WatchDataDto(workouts: workouts, trainings: trainings).toJSONString() ?? ""
    }

    func sendValue(_ value: [String: Any]) {
        if checkIfPairedAppInstalled() {
            WCSession.default.sendMessage(value) { _ in }
        }
    }
}

struct WatchConnectivityManager {
    var sendValue: @Sendable (_ value: [String: Any]) -> Void
    var checkIfPairedAppInstalled: @Sendable () -> Bool
}

extension WatchConnectivityManager: DependencyKey {
    static var liveValue = Self(
        sendValue: {
            ConnectivityManager.shared.sendValue($0)
        },
        checkIfPairedAppInstalled: {
            ConnectivityManager.shared.checkIfPairedAppInstalled()
        }
    )
}
