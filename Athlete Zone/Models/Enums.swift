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

enum ActivityType: String, Identifiable, CaseIterable, Encodable {
    var id: Int {
        hashValue
    }

    case work = "Work"
    case rest = "Rest"
    case series = "Series"
    case rounds = "Rounds"
    case reset = "Reset"
}

enum WorkFlowType: String {
    case preparation = "Get ready!"
    case work = "Work"
    case rest = "Rest"
    case series = "Series"
    case rounds = "Rounds"
    case reset = "Reset"
}

enum WorkFlowState {
    case ready, running, paused, finished, quit
}

enum LabelType {
    case time, number
}

enum InputType {
    case time, number, text
}

enum Language: String, Equatable, CaseIterable {
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

enum Section: String, CaseIterable {
    case workout = "Workout"
    case training = "Training"
}

enum LaunchScreenStep {
    case firstStep
    case secondStep
    case finished
}
