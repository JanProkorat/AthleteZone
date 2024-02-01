//
//  Int.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 13.11.2022.
//

import Foundation

extension Int {
    func isEven() -> Bool {
        return self.isMultiple(of: 2)
    }

    func isOdd() -> Bool {
        return !self.isEven()
    }

    func toHours() -> Int {
        return self / 3600
    }

    func toMinutes() -> Int {
        return (self % 3600) / 60
    }

    func toSeconds() -> Int {
        return (self % 3600) % 60
    }

    func toFormattedValue(type: LabelType) -> String {
        switch type {
        case .time:
            return self.toFormattedTime()

        case .number:
            return self.toFormattedNumber()
        }
    }

    func toFormattedNumber() -> String {
        return "\(self)x"
    }

    func toFormattedTime() -> String {
        let formatter = DateComponentsFormatter()
        formatter.zeroFormattingBehavior = .pad
        formatter.allowedUnits = [.minute, .second]
        if self >= 3600 {
            formatter.allowedUnits.insert(.hour)
        }
        return formatter.string(from: TimeInterval(self))!
    }

    func toInterval(mins: Int, secs: Int) -> Int {
        return self * 3600 + mins * 60 + secs
    }

    func toInterval(hours: Int, secs: Int) -> Int {
        return hours * 3600 + self * 60 + secs
    }

    func toInterval(hours: Int, mins: Int) -> Int {
        return hours * 3600 + mins * 60 + self
    }
}
