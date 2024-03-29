//
//  LiveActivityManager.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 27.09.2023.
//

import ActivityKit
import Foundation

class LiveActivityManager: LiveActivityProtocol {
    static let shared = LiveActivityManager()
    var activity: Activity<AthleteZoneWidgetAttributes>?

    func startActivity(workFlow: WorkFlow, workoutName: String) {
        if ActivityAuthorizationInfo().areActivitiesEnabled, activity == nil {
            let initialState = AthleteZoneWidgetAttributes.ContentState(
                workFlow: workFlow,
                name: workoutName,
                state: .running
            )
            do {
                activity = try Activity.request(
                    attributes: AthleteZoneWidgetAttributes(),
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

    func updateActivity(workFlow: WorkFlow, workoutName: String, state: WorkFlowState) {
        Task {
            let updatedContentState = AthleteZoneWidgetAttributes.ContentState(
                workFlow: workFlow,
                name: workoutName,
                state: state
            )
            await activity?.update(
                ActivityContent<AthleteZoneWidgetAttributes.ContentState>(
                    state: updatedContentState,
                    staleDate: Date().addingTimeInterval(0.01)
                )
            )
        }
    }

    func listAllActivities() -> [[String: String]] {
        let sortedActivities = Activity<AthleteZoneWidgetAttributes>.activities.sorted { $0.id > $1.id }
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
