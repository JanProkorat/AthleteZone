//
//  ConnectivityManager.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 22.11.2023.
//

import Foundation
import WatchConnectivity

final class ConnectivityManager: NSObject, WCSessionDelegate, ConnectivityProtocol {
    static let shared = ConnectivityManager()

    @Published var activationState: WCSessionActivationState = .notActivated
    @Published var isSessionReachable = false
    @Published var receivedMessage: [String: Any]?

    var isSessionReachablePublisher: Published<Bool>.Publisher { self.$isSessionReachable }
    var receivedMessagePublisher: Published<[String: Any]?>.Publisher { self.$receivedMessage }
    var activationStatePublisher: Published<WCSessionActivationState>.Publisher { self.$activationState }

    override private init() {
        super.init()

        WCSession.default.delegate = self
        WCSession.default.activate()
    }
}

// MARK: - WCSessionDelegate

extension ConnectivityManager {
    func session(_ session: WCSession,
                 activationDidCompleteWith activationState:
                 WCSessionActivationState, error: Error?)
    {
        self.activationState = activationState
        switch activationState {
        case .activated:
            print("Watch Activated")

        case .notActivated:
            print("Watch Not Activated")

        case .inactive:
            print("Watch Inactive")
        @unknown default:
            break
        }
    }

    func session(_ session: WCSession,
                 didReceiveMessage message: [String: Any],
                 replyHandler: @escaping ([String: Any]) -> Void)
    {
        DispatchQueue.main.async {
            self.receivedMessage = message
        }
    }

    func requestData() {
        guard WCSession.default.activationState == .activated else {
            print("Session not in active state")
            return
        }

        guard WCSession.default.isCompanionAppInstalled else {
            print("iOS app not installed")
            return
        }

        WCSession.default.sendMessage(["data": "data"]) { newValue in
            DispatchQueue.main.async {
                self.receivedMessage = newValue
            }

        } errorHandler: { error in
            print(["Error sending data request", error.localizedDescription])
        }
    }

    func sessionReachabilityDidChange(_ session: WCSession) {
        self.isSessionReachable = session.isReachable
    }

    func isIosAppInstalled() -> Bool {
        return WCSession.default.isCompanionAppInstalled
    }
}
