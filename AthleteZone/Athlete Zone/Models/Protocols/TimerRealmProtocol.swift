//
//  TimerRealmProtocol.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 18.03.2024.
//

import Foundation

protocol TimerRealmProtocol {
    func load() -> [TimerDto]
    func add(interval: TimeInterval)
}
