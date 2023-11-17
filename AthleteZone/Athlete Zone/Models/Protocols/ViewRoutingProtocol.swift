//
//  ViewRoutingProtocol.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 14.11.2023.
//

import Foundation

protocol ViewRoutingProtocol: ObservableObject {
    var currentTab: Tab { get set }
    var currentSection: Section { get set }

    var currentTabPublisher: Published<Tab>.Publisher { get }
    var currentSectionPublisher: Published<Section>.Publisher { get }
}
