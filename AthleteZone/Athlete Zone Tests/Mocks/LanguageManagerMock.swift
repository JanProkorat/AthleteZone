//
//  LanguageManagerMock.swift
//  Athlete Zone Tests
//
//  Created by Jan Prokorát on 14.11.2023.
//

@testable import Athlete_Zone
import Foundation

class LanguageManagerMock: LanguageProtocol {
    @Published var language: Language = .en
    var languagePublisher: Published<Language>.Publisher { $language }
}
