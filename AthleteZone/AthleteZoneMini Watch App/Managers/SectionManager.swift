//
//  SectionManager.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 24.08.2023.
//

import Foundation

class SectionManager: ObservableObject {
    static var shared = SectionManager()

    @Published var currentSection: Section = .workout

}
