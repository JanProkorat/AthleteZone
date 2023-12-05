//
//  TimeInterval.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 30.11.2023.
//

import Foundation

extension TimeInterval {
    func toFormattedTime() -> String {
        let milliseconds = Int((self.truncatingRemainder(dividingBy: 1)) * 100)
        let seconds = Int(self) % 60
        let minutes = Int(self) / 60
        let hours = Int(self) / 3600

        if hours > 0 {
            return String(format: "%02d:%02d:%02d,%02d", hours, minutes, seconds, milliseconds)
        } else {
            return String(format: "%02d:%02d,%02d", minutes, seconds, milliseconds)
        }
    }
}
