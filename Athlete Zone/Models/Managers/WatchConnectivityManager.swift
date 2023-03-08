//
//  WatchConnectivityManager.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 10.01.2023.
//

import Foundation
import WatchConnectivity

final class WatchConnectivityManager: NSObject, ObservableObject {
    static let shared = WatchConnectivityManager()

    var appStorageManager = AppStorageManager.shared

    @Published var receivedData: [WorkOut]?
    @Published var isSessionReachable = false

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

        WCSession.default.sendMessage(["data": Section.workout.rawValue]) { newValue in
            DispatchQueue.main.async {
                self.decodeMessage(newValue)
            }

        } errorHandler: { error in
            print(error.localizedDescription)
        }
    }

    func loadReplyData() -> String {
        let realmManager = RealmManager()
        let data = realmManager.load(entity: WorkOut.self)
        return data.toJSONString() ?? ""
    }

    func sessionReachabilityDidChange(_ session: WCSession) {
        self.isSessionReachable = session.isReachable
    }

    func sendValue(_ value: [String: Any]) {
        WCSession.default.sendMessage(value) { _ in }
    }

    func decodeMessage(_ message: [String: Any]) {
        do {
            if let dataString = message["data"] as? String {
                self.receivedData = try JSONDecoder().decode([WorkOut].self, from: Data(dataString.utf8))
            }
            if let language = message[DefaultItem.language.rawValue] as? String {
                self.appStorageManager.language = Language(rawValue: language) ?? .en
            }
            if let sounds = message[DefaultItem.soundsEnabled.rawValue] as? Bool {
                self.appStorageManager.soundsEnabled = sounds
            }
            if let sounds = message[DefaultItem.hapticsEnabled.rawValue] as? Bool {
                self.appStorageManager.hapticsEnabled = sounds
            }
            if let workout: WorkOut = try (message["workout_add"] as? String)?.decode() {
                if self.receivedData != nil {
                    self.receivedData!.append(workout)
                } else {
                    self.receivedData = [workout]
                }
            }
            if let workout: WorkOut = try (message["workout_edit"] as? String)?.decode() {
                self.receivedData = self.receivedData?.map {
                    if $0._id == workout._id {
                        $0.name = workout.name
                        $0.work = workout.work
                        $0.rest = workout.rest
                        $0.series = workout.series
                        $0.rounds = workout.rounds
                        $0.reset = workout.reset
                    }
                    return $0
                }
            }
            if let workoutId = message["workout_remove"] as? String {
                self.receivedData?.removeAll { $0._id.stringValue == workoutId }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
