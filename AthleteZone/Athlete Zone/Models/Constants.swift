//
//  Constants.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 05.11.2022.
//

import Foundation
import SwiftUI

enum Icons: String, CaseIterable {
    case actionsForward = "Actions_forward"
    case actionsPause = "Actions_pause"
    case add = "Add_Square"
    case arrowDown = "Arrow_down"
    case avatar = "Avatar"
    case avatarActive = "Avatar_active"
    case book = "Book"
    case bookActive = "Book_active"
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
    case allowNotifications
    case allowNotificationsDescription
    case haptics
    case healthKitAccess
    case healthKitAccessDescription1
    case healthKitAccessDescription2
    case runInBackground
    case runInBackgroundDescription

    // Workout edit
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

    // Subscription
    case active
    case subscriptionDescription
}
