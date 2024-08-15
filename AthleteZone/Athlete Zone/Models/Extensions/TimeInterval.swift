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

    func toFormattedTimeForTimer() -> String {
        let seconds = Int(self) % 60
        let minutes = Int(self) / 60
        let hours = Int(self) / 3600

        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }

    func toFormattedTimeForWorkout() -> String {
        let milliseconds = Int((self.truncatingRemainder(dividingBy: 1)) * 100)
        let seconds = Int(self) % 60
        let minutes = Int(self) / 60
        let hours = Int(self) / 3600

        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds, milliseconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds, milliseconds)
        }
    }

    func formatElapsedTime() -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = [.pad]

        return formatter.string(from: self) ?? "00:00:00"
    }

    func isTimeElapsedZero(withTolerance tolerance: TimeInterval = 1e-9) -> Bool {
        return abs(self) < tolerance
    }

    func rounded(toPlaces places: Int) -> TimeInterval {
        let multiplier = pow(10.0, Double(places))
        return (self * multiplier).rounded() / multiplier
    }
}
