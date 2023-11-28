//
//  WatchConnectivityManagerProtocol.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 22.07.2023.
//

import Foundation

protocol WatchConnectivityProtocol {
    var lastSentMessage: [String: Any]? { get set }

    func sendValue(_ value: [String: Any])
    func checkIfPairedAppInstalled() -> Bool
}
