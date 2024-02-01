//
//  StateManager.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 17.01.2024.
//

import Foundation

class StateManager: StateProtocol {
    static let shared = StateManager()

    @Published var state: WorkFlowState = .ready

    var statePublisher: Published<WorkFlowState>.Publisher {
        $state
    }

    func setState(_ state: WorkFlowState) {
        self.state = state
    }
}
