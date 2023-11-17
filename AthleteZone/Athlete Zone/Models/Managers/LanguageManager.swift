//
//  LanguageManager.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 19.07.2023.
//

import Foundation

class LanguageManager: LanguageProtocol {
    static let shared = LanguageManager()

    @Published var language: Language = .en
    var languagePublisher: Published<Language>.Publisher { $language }
}
