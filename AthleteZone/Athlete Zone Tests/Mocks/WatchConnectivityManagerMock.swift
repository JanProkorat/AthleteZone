//
//  WatchConnectivityManagerMock.swift
//  Athlete Zone Tests
//
//  Created by Jan Prokorát on 22.07.2023.
//

@testable import Athlete_Zone
import Foundation

class WatchConnectivityMock: WatchConnectivityProtocol {
    var lastSentMessage: [String: Any]?

    func sendValue(_ value: [String: Any]) {
        lastSentMessage = value
    }
}
