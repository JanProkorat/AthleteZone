//
//  StateProtocol.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 17.01.2024.
//

import Foundation

protocol StateProtocol: ObservableObject {
    var state: WorkFlowState { get }
    var statePublisher: Published<WorkFlowState>.Publisher { get }

    func setState(_ state: WorkFlowState)
}
