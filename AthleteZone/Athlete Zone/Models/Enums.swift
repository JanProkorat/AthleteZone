//
//  Enums.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 05.11.2022.
//

import Foundation

enum Tab: Int, CaseIterable {
    case home = 0
    case library = 1
    case setting = 2
}

enum ActivityType: String, Identifiable, CaseIterable, Encodable {
    var id: Int {
        hashValue
    }

    case work
    case rest
    case series
    case rounds
    case reset
}

enum WorkFlowType: String, Codable {
    case preparation
    case work
    case rest
    case series
    case rounds
    case reset
}

enum WorkFlowState: String, Codable {
    case ready, running, paused, finished, quit
}

enum LabelType {
    case time, number
}

enum InputType {
    case time, number, text
}

enum Language: String, Equatable, CaseIterable, Codable {
    case cze = "CZ"
    case de = "DE"
    case en = "EN"
}

enum SortOrder: String, CaseIterable, Identifiable {
    var id: Int {
        hashValue
    }

    case ascending
    case descending
}

protocol SortByProperty: CaseIterable, Hashable, Identifiable {}

enum WorkOutSortByProperty: String, SortByProperty {
    var id: Int {
        hashValue
    }

    case name
    case work
    case rest
    case reset
    case series
    case rounds
    case workoutLength
    case createdDate
}

enum TrainingSortByProperty: String, SortByProperty {
    var id: Int {
        hashValue
    }

    case name
    case trainingLength
    case numOfWorkouts
    case createdDate
}

enum StopWatchSortByProperty: String, SortByProperty {
    var id: Int {
        hashValue
    }

    case name
    case startDate
    case endDate
    case activityLength
}

enum Section: String, CaseIterable, Codable, Identifiable {
    var id: Int {
        hashValue
    }

    case workout
    case training
    case stopWatch
}

enum LaunchScreenStep {
    case firstStep
    case secondStep
    case finished
}

enum TransferDataKey: String {
    case data
    case soundsEnabled
    case hapticsEnabled
    case language
    case workoutAdd
    case workoutEdit
    case workoutRemove
    case trainingAdd
    case trainingEdit
    case trainingRemove
}

enum TimerType: String, Identifiable {
    var id: Int {
        hashValue
    }

    case stopWatch
    case timer
}

enum TimerKind: String {
    case workout
    case stopWatch
}
