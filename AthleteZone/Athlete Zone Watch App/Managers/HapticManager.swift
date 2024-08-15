//
//  HapticManager.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 17.02.2023.
//

import Dependencies
import Foundation
import WatchKit

struct HapticManager: DependencyKey {
    var playHaptic: @Sendable (_ type: WKHapticType) -> Void

    static var liveValue = Self(
        playHaptic: { type in
            WKInterfaceDevice.current().play(type)
        })
}
