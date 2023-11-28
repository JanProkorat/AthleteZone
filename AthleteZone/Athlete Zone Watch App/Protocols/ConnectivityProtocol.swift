//
//  ConnectivityProtocol.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 23.11.2023.
//

import Foundation
import WatchConnectivity

protocol ConnectivityProtocol: ObservableObject {
    var isSessionReachable: Bool { get set }
    var receivedMessage: [String: Any]? { get set }
    var activationState: WCSessionActivationState { get set }

    var isSessionReachablePublisher: Published<Bool>.Publisher { get }
    var receivedMessagePublisher: Published<[String: Any]?>.Publisher { get }
    var activationStatePublisher: Published<WCSessionActivationState>.Publisher { get }

    func requestData()
    func isIosAppInstalled() -> Bool
}
