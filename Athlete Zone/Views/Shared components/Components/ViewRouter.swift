//
//  ViewRouter.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 07.11.2022.
//

import SwiftUI

class ViewRouter: ObservableObject {
    static let shared = ViewRouter()

    @Published var currentTab: Tab = .home
    @Published var currentSection: Section = .workout
}
