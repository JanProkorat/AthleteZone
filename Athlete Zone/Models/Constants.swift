//
//  Constants.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 05.11.2022.
//

import Foundation

enum Icons {
    static let ActionsForward = "Actions_forward"
    static let ActionsPause = "Actions_pause"
    static let Add = "Add"
    static let ArrowDown = "Arrow_down"
    static let Avatar = "Avatar"
    static let AvatarActive = "Avatar_active"
    static let Book = "Book"
    static let BookActive = "Book_active"
    static let Clear = "Clear"
    static let Donate = "Donate"
    static let FlagCZ = "CZ"
    static let FlagDE = "DE"
    static let FlagGB = "GB"
    static let Forward = "Forward"
    static let Home = "Home"
    static let HomeActive = "Home_active"
    static let Check = "Check"
    static let Menu = "Menu"
    static let Pause = "Pause"
    static let Play = "Play"
    static let Repeat = "Repeat"
    static let Save = "Save"
    static let Setting = "Setting"
    static let SettingActive = "Setting_active"
    static let Start = "Start"
    static let Stop = "Stop"
    static let Time = "Time"
    static let Trash = "Trash"
}

enum Pictures {
    static let Logo = "Logo"
    static let Welcome = "Welcome"
}

enum ComponentColor: String, CaseIterable {
    case action = "Action"
    case braun = "Braun"
    case darkBlue = "Dark_blue"
    case mainText = "Main_text"
    case menuText = "Menu_text"
    case menuItemSelected = "Menu_item_selected"
    case menu = "Menu"
    case purple = "Purple"
    case reset = "Reset"
    case rest = "Rest"
    case rounds = "Rounds"
    case series = "Series"
    case work = "Work"

    case pink = "Pink"
    case yellow = "Yellow"
    case none = ""
}

enum Background: String, CaseIterable {
    case background = "Background"
    case reset = "Reset_background"
    case rest = "Rest_background"
    case rounds = "Rounds_background"
    case series = "Series_background"
    case work = "Work_background"
}

enum DefaultItem: String {
    case language
    case selectedWorkoutId
}
