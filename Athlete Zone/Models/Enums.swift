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

enum LabelType {
    case time, number
}

enum Language: String, CaseIterable {
    case cze, de, en
}
