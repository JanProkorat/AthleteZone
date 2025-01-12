//
//  WorkFlowState.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 05.01.2025.
//

import Foundation

extension WorkFlowState {
    func getIcon() -> Icon {
        switch self {
        case .preparation:
            return Icon.actionsPause

        case .running:
            return Icon.actionsPause

        case .finished:
            return Icon.repeatIcon

        case .paused:
            return Icon.start

        case .ready:
            return Icon.start

        case .quit:
            return Icon.start
        }
    }
}
