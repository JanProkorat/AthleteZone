//
//  LanguageProtocol.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 14.11.2023.
//

import Foundation

protocol LanguageProtocol: ObservableObject {
    var language: Language { get set }

    var languagePublisher: Published<Language>.Publisher { get }
}
