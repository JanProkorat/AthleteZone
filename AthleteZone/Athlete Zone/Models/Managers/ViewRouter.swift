//
//  ViewRouter.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 07.11.2022.
//

import SwiftUI

class ViewRouter: ViewRoutingProtocol {
    static var shared = ViewRouter()

    @Published var currentTab: Tab = .home
    @Published var currentSection: Section = .workout

    var currentTabPublisher: Published<Tab>.Publisher { $currentTab }
    var currentSectionPublisher: Published<Section>.Publisher { $currentSection }
}
