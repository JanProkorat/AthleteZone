//
//  Int.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 13.11.2022.
//

import Foundation

extension Int {
    
    func isIven() -> Bool {
        return self % 2 == 0
    }
    
    func isOdd() -> Bool {
        return self % 2 != 0
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
            return "\(self)x"
        }
        
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
}
