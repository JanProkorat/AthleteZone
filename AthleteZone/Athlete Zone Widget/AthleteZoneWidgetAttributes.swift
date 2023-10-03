//
//  AthleteZoneWidgetsAttributes.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 28.09.2023.
//

import ActivityKit
import Foundation

struct AthleteZoneWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var workFlow: WorkFlow
        var name: String
    }
}
