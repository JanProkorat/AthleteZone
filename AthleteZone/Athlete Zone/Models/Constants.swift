//
//  Constants.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 05.11.2022.
//

import Foundation

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
    case flagGB = "GB"
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
    case reset = "Reset"
    case rest = "Rest"
    case rounds = "Rounds"
    case series = "Series"
    case work = "Work"

    case lightPink = "Light_Pink"
    case lightYellow = "Light_Yellow"
    case buttonGreen = "Button_Green"
    case lightBlue = "Light_blue"
    case lightGreen = "Light_green"
    case none = ""
}

enum Background: String, CaseIterable {
    case background = "Background"
    case sheetBackground = "Sheet_background"
    case reset = "Reset_background"
    case rest = "Rest_background"
    case rounds = "Rounds_background"
    case series = "Series_background"
    case work = "Work_background"
    case listItemBackground = "List_item_Background"
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
