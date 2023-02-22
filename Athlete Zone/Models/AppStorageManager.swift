//
//  AppStorageManager.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 19.02.2023.
//

import Foundation
import SwiftUI

class AppStorageManager: ObservableObject {
    static let shared = AppStorageManager()

    @AppStorage(DefaultItem.language.rawValue) var language: Language = .en
    @AppStorage(DefaultItem.soundsEnabled.rawValue) var soundsEnabled = true
    @AppStorage(DefaultItem.hapticsEnabled.rawValue) var hapticsEnabled = true
}
