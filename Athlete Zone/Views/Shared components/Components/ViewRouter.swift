//
//  ViewRouter.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 07.11.2022.
//

import SwiftUI

class ViewRouter: ObservableObject {
    @Published var currentTab: Tab = .home
    @Published var currentSection: Section = .workout
}
