//
//  RunningWorkoutWidgetAttributes.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 08.08.2023.
//

import ActivityKit
import Foundation

struct RunningWorkoutWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var workFlow: WorkFlow
        var name: String
    }

}
