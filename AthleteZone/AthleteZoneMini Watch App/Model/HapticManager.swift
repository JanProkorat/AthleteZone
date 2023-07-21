//
//  HapticManager.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 17.02.2023.
//

import Foundation
import WatchKit

class HapticManager: HapticProtocol {
    private let device = WKInterfaceDevice.current()

    func playHaptic() {
        self.device.play(.start)
    }

    func playFinishHaptic() {
        self.device.play(.success)
    }
}
