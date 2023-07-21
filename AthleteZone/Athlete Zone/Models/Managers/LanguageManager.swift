//
//  LanguageManager.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 19.07.2023.
//

import Foundation

class LanguageManager: ObservableObject {
    static let shared = LanguageManager()

    @Published var language: Language = .en
}
