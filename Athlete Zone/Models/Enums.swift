//
//  Enums.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 05.11.2022.
//

import Foundation

enum Tab {
    case home, library, profile, setting, exerciseRun
}

enum ActivitySheet: Identifiable {
    case work, rest, rounds, series, reset
    
    var id: Int {
        hashValue
    }
}

enum ActivityType: String, CustomStringConvertible {
    var description: String {
        return self.rawValue
    }
    
    case work = "Work"
    case rest = "Rest"
    case reset = "Reset time"
}

enum LabelType {
    case time, number
}

enum InputType {
    case time, number, text
}

enum Language: String, CaseIterable {
    case cze, de, en
}
