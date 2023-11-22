//
//  LiveActivityProtocol.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 21.11.2023.
//

import ActivityKit
import Foundation

protocol LiveActivityProtocol {
    var activity: Activity<AthleteZoneWidgetAttributes>? { get set }

    func startActivity(workFlow: WorkFlow, workoutName: String)
    func updateActivity(workFlow: WorkFlow, workoutName: String)
    func listAllActivities() -> [[String: String]]
    func endActivity()
}
