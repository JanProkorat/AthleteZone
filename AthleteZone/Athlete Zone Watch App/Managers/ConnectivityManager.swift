//
//  ConnectivityManager.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 22.11.2023.
//

import Dependencies
import Foundation
import os
import WatchConnectivity

final class ConnectivityManager: NSObject, WCSessionDelegate, ObservableObject {
    static let shared = ConnectivityManager()

    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: ConnectivityManager.self)
    )

    @Published var isSessionReachable = false
    @Published var receivedMessage: [String: String]?

    override private init() {
        super.init()

        WCSession.default.delegate = self
        WCSession.default.activate()
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        switch activationState {
        case .activated:
            logger.info("Watch Activated")

        case .notActivated:
            logger.info("Watch Not Activated")

        case .inactive:
            logger.info("Watch Inactive")

        @unknown default:
            break
        }
    }

    func session(_ session: WCSession, didReceiveMessage message: [String: Any], replyHandler: @escaping ([String: Any]) -> Void) {
        receivedMessage = message.mapValues { $0 as? String ?? "" }
    }

    func requestData() {
        guard WCSession.default.activationState == .activated else {
            logger.error("Session not in active state")
            return
        }

        guard WCSession.default.isCompanionAppInstalled else {
            logger.error("iOS app not installed")
            return
        }

        WCSession.default.sendMessage([DefaultItem.initData.rawValue: DefaultItem.initData.rawValue]) { newValue in
            DispatchQueue.main.async {
                self.receivedMessage = newValue.mapValues { $0 as? String ?? "" }
            }
        } errorHandler: { error in
            self.logger.error("Error sending data request: \(error.localizedDescription)")
        }
    }

    func sessionReachabilityDidChange(_ session: WCSession) {
        logger.info("Session reachable: \(session.isReachable)")
        DispatchQueue.main.async {
            self.isSessionReachable = session.isReachable
        }
    }

    func isIosAppInstalled() -> Bool {
        return WCSession.default.isCompanionAppInstalled
    }
}

struct WatchConnectivityManager {
    var requestData: @Sendable () -> Void
    var isIosAppInstalled: @Sendable () -> Bool
    var isSessionRachable: @Sendable () -> Bool
    var getManager: @Sendable () -> ConnectivityManager
}

extension WatchConnectivityManager: DependencyKey {
    static var liveValue = Self(
        requestData: {
            ConnectivityManager.shared.requestData()
        },
        isIosAppInstalled: {
            ConnectivityManager.shared.isIosAppInstalled()
        },
        isSessionRachable: {
            ConnectivityManager.shared.isSessionReachable
        },
        getManager: { ConnectivityManager.shared }
    )
}
