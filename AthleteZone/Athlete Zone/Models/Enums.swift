//
//  Enums.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 05.11.2022.
//

import Foundation
import SwiftUI

enum Tab: Int, CaseIterable {
    case home = 0
    case library = 1
    case settings = 2
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
    case ready, preparation, running, paused, finished, quit
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

enum Icon: String, CaseIterable {
    case actionsForward = "Actions_forward"
    case actionsPause = "Actions_pause"
    case add = "Add_Square"
    case addLarge = "Add_large"
    case arrowDown = "Arrow_down"
    case avatar = "Avatar"
    case avatarActive = "Avatar_active"
    case book = "Book"
    case bookActive = "Book_active"
    case bookLarge = "Book_large"
    case clear = "Clear"
    case donate = "Donate"
    case flagCZ = "CZ"
    case flagDE = "DE"
    case flagGB = "EN"
    case forward = "Forward"
    case home = "Home"
    case homeActive = "Home_active"
    case check = "Check"
    case menu = "Menu"
    case pause = "Pause"
    case play = "Play"
    case repeatIcon = "Repeat"
    case save = "Save"
    case setting = "Setting"
    case settingActive = "Setting_active"
    case start = "Start"
    case stop = "Stop"
    case stopWatch = "StopWatch"
    case time = "Time"
    case trash = "Trash"
}

enum Picture: String {
    case logo = "Logo"
    case logo2 = "Logo2"
    case background = "Background"
    case background2 = "Background2"
    case background3 = "Background3"
    case welcome = "Welcome"
    case headline = "Headline"
    case headline2 = "Headline2"
}

enum ComponentColor: String, CaseIterable, Codable {
    case action = "Action"
    case braun = "Braun"
    case darkBlue = "Dark_blue"
    case darkGrey = "Dark_grey"
    case grey = "Grey"
    case mainText = "Main_text"
    case menuText = "Menu_text"
    case menuItemSelected = "Menu_item_selected"
    case menu = "Menu"
    case purple = "Light_Purple"

    case lightPink = "Light_Pink"
    case lightYellow = "Light_Yellow"
    case buttonGreen = "Button_Green"
    case lightBlue = "Light_blue"
    case lightGreen = "Light_green"
    case none = ""
}

enum DefaultItem: String {
    case initData
    case language
    case selectedWorkoutId
    case selectedTrainingId
    case soundsEnabled
    case hapticsEnabled
    case notificationsEnabled
    case notificationsAllowed
    case selectedSection
    case backupData
    case stopWatchType
    case runInBackground
}

enum Sound: String, CaseIterable {
    case beep
    case gong
    case fanfare
}

enum UserDefaultValues: String {
    case groupId = "group.com.janprokorat.Athlete-Zone"
    case workoutId = "selectedWorkout"
    case trainingId = "selectedTraining"
    case widgetId = "AthleteZoneWidget"
}

enum LocalizationKey: String {
    var localizedKey: LocalizedStringKey {
        LocalizedStringKey(rawValue)
    }

    var stringValue: String {
        let preferredLanguage = Bundle.main.preferredLocalizations.first ?? "en"
        if let path = Bundle.main.path(forResource: preferredLanguage, ofType: "lproj"),
           let bundle = Bundle(path: path)
        {
            return bundle.localizedString(forKey: rawValue, value: nil, table: nil)
        }
        return ""
    }

    case appTitle
    case premiumSubscription = "Athlete Zone+"

    // Actions
    case save
    case cancel
    case delete
    case edit
    case close
    case yes
    case no
    case activate

    // Menu
    case home
    case library
    case settings

    // Workout
    case work
    case rest
    case series
    case rounds
    case reset
    case createdDate
    case workoutLength
    case name

    // Library
    case noWorkoutsToDisplay
    case noTrainingsToDisplay
    case sortBy
    case sortOrder
    case search
    case ascending
    case descending

    // Settings
    case language
    case sounds
    case soundsDescription
    case allowNotifications
    case allowNotificationsDescription
    case haptics
    case hapticsDescription
    case healthKitAccess
    case healthKitAccessDescription1
    case healthKitAccessDescription2
    case healthKitAccessDescription3
    case runInBackground
    case runInBackgroundDescription

    // Workout edit
    case saveWorkout
    case addWorkout
    case editWorkout
    case enterName

    // Workout remove
    case removeConfirm

    // Workout run
    case preparation
    case previousExercise
    case quitWorkout

    // Watch
    case filters
    case actions

    // Notifications
    case notification1
    case notification2
    case notification3
    case notification4

    // Training
    case numOfWorkouts
    case trainingLength
    case length
    case workouts
    case description
    case summary
    case noTrainingSelected
    case noWorkoutsInTraining

    // Sections
    case workout
    case training
    case stopWatch
    case timer

    // Edit training
    case enterDescription
    case addWorkouts
    case selectWorkouts
    case addTraining
    case editTraining
    case total
    case workoutsInTraining

    // StopWatch
    case history
    case start
    case end
    case noActivities
    case splitTimes
    case quitTracking
    case enterNameLabel
    case namePlaceholder
    case startDate
    case endDate
    case activityLength
    case editActivity
    case noSplitTimes
    case lastActivity
    case recent
    case newActivity
    case go
    case paused
    case finished

    // Subscription
    case active
    case subscriptionDescription
}
