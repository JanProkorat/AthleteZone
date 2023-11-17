//
//  ViewRouterMock.swift
//  Athlete Zone Tests
//
//  Created by Jan Prokorát on 14.11.2023.
//

@testable import Athlete_Zone
import Foundation

class ViewRouterMock: ViewRoutingProtocol {
    @Published var currentTab: Tab = .home
    @Published var currentSection: Section = .workout

    var currentTabPublisher: Published<Tab>.Publisher { $currentTab }
    var currentSectionPublisher: Published<Section>.Publisher { $currentSection }
}
