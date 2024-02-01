//
//  WidgetActionIntent.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 17.01.2024.
//

import AppIntents
import Foundation

struct LiveActivityActionIntent: LiveActivityIntent {
    static var title: LocalizedStringResource = "Start last activity"

    @Parameter(title: "Activity state")
    var state: String

    init() {}

    init(_ state: WorkFlowState) {
        self.state = state.rawValue
    }

    func perform() async throws -> some IntentResult {
        StateManager.shared.setState(WorkFlowState(rawValue: state) ?? .paused)
        return .result()
    }
}
