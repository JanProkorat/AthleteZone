//
//  LiveActivityManager.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 27.09.2023.
//

import ActivityKit
import Foundation

class LiveActivityManager {
    static let shared = LiveActivityManager()
    private var activity: Activity<AthleteZoneWidgetsAttributes>?

    func startActivity(workFlow: WorkFlow, workoutName: String) {
        if ActivityAuthorizationInfo().areActivitiesEnabled, activity == nil {
            let initialState = AthleteZoneWidgetsAttributes.ContentState(
                workFlow: workFlow,
                name: workoutName
            )
            do {
                activity = try Activity.request(
                    attributes: AthleteZoneWidgetsAttributes(),
                    content: ActivityContent(
                        state: initialState,
                        staleDate: Date()
                    )
                )
            } catch {
                print("Error requesting delivery Live Activity \(error.localizedDescription).")
            }
        }
    }

    func updateActivity(workFlow: WorkFlow, workoutName: String) {
        Task {
            let updatedContentState = AthleteZoneWidgetsAttributes.ContentState(
                workFlow: workFlow,
                name: workoutName
            )
            await activity?
                .update(
                    ActivityContent(
                        state: updatedContentState,
                        staleDate: Date().addingTimeInterval(0.01)
                    )
                )
        }
    }

    func listAllActivities() -> [[String: String]] {
        let sortedActivities = Activity<AthleteZoneWidgetsAttributes>.activities.sorted { $0.id > $1.id }
        return sortedActivities.map {
            ["id": $0.id,
             "workFlow": $0.content.state.workFlow.encode(),
             "name": $0.content.state.name]
        }
    }

    func endActivity() {
        Task {
            await activity?.end(activity?.content, dismissalPolicy: .immediate)
            activity = nil
        }
    }
}
