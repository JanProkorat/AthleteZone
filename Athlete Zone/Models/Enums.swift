//
//  Enums.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 05.11.2022.
//

import Foundation

enum Tab {
    case home, library, profile, setting, workoutRun
}

enum ActivityType: String, CustomStringConvertible, Identifiable, CaseIterable {
    var description: String {
        self.rawValue
    }

    var id: Int {
        hashValue
    }

    case work = "Work"
    case rest = "Rest"
    case series = "Series"
    case rounds = "Rounds"
    case reset = "Reset"
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

enum SortOrder: String, CaseIterable, Identifiable {
    var id: Int {
        hashValue
    }

    case ascending = "Ascending"
    case descending = "Descending"
}

enum SortByProperty: String, CaseIterable, Identifiable {
    var id: Int {
        hashValue
    }

    case name = "Name"
    case work = "Work"
    case rest = "Rest"
    case series = "Series"
    case rounds = "Rounds"
    case reset = "Reset"
    case createdDate = "Created date"
    case workoutLength = "Workout length"
}
