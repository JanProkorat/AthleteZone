//
//  AthleteZoneWidgetsLiveActivity.swift
//  AthleteZoneWidgets
//
//  Created by Jan Prokorát on 28.09.2023.
//

import ActivityKit
import Intents
import SwiftUI
import WidgetKit

struct AthleteZoneWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: AthleteZoneWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            HStack {
                Button(intent: LiveActivityActionIntent(context.state.state == .running ? .paused : .running)) {
                    Image(systemName: context.state.state == .running ? "pause.circle.fill" : "play.circle.fill")
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: 30, maxHeight: 30)
                        .padding(.leading, 20)
                        .padding([.top, .bottom], 2)
                        .foregroundColor(Color(context.state.workFlow.color.rawValue))
                }
                .buttonStyle(.plain)

                Button(intent: LiveActivityActionIntent(.quit)) {
                    Image(systemName: "stop.circle.fill")
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: 30, maxHeight: 30)
                        .padding([.top, .bottom], 2)
                        .foregroundColor(Color(context.state.workFlow.color.rawValue))
                }
                .buttonStyle(.plain)

                Text(context.state.workFlow.label)
                    .frame(alignment: .leading)
                    .foregroundStyle(Color(context.state.workFlow.color.rawValue))
                    .font(.title3)
                    .padding(.leading, 5)

                Text(context.state.workFlow.interval.toFormattedTimeForWorkout())
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .foregroundStyle(Color(context.state.workFlow.color.rawValue))
                    .font(.title)
                    .frame(alignment: .trailing)
                    .padding(.trailing)
            }
            .activityBackgroundTint(Color(ComponentColor.darkGrey.rawValue))
            .frame(maxWidth: .infinity, maxHeight: .infinity)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.bottom) {
                    DynamicIslandExpandedView(
                        workflow: context.state.workFlow,
                        name: context.state.name,
                        state: context.state.state
                    )
                }
            } compactLeading: {
                HStack {
                    Image(systemName: context.state.workFlow.icon)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: 15, maxHeight: 15)
                        .foregroundColor(Color(context.state.workFlow.color.rawValue))
                        .padding([.leading], 5)

                    Text(context.state.workFlow.label)
                        .font(.subheadline)
                        .foregroundStyle(Color(context.state.workFlow.color.rawValue))
                }
            } compactTrailing: {
                Text(context.state.workFlow.interval.toFormattedTimeForWorkout())
                    .font(.subheadline)
                    .foregroundStyle(Color(context.state.workFlow.color.rawValue))
                    .padding(.trailing, 5)
            } minimal: {
                Image(systemName: context.state.workFlow.icon)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: 20, maxHeight: 20)
                    .foregroundColor(Color(context.state.workFlow.color.rawValue))
            }
        }
    }
}

#Preview("Notification", as: .content, using: AthleteZoneWidgetAttributes()) {
    AthleteZoneWidgetLiveActivity()
} contentStates: {
    AthleteZoneWidgetAttributes.ContentState(
        workFlow: WorkFlow(
            interval: 10,
            type: .preparation,
            round: 1,
            serie: 1,
            totalSeries: 3,
            totalRounds: 4
        ), name: "Workout",
        state: .running
    )
    AthleteZoneWidgetAttributes.ContentState(
        workFlow: WorkFlow(
            interval: 9,
            type: .work,
            round: 1,
            serie: 1,
            totalSeries: 3,
            totalRounds: 4
        ), name: "Workout",
        state: .running
    )
    AthleteZoneWidgetAttributes.ContentState(
        workFlow: WorkFlow(
            interval: 8,
            type: .rest,
            round: 1,
            serie: 1,
            totalSeries: 3,
            totalRounds: 4
        ), name: "Workout",
        state: .running
    )
    AthleteZoneWidgetAttributes.ContentState(
        workFlow: WorkFlow(
            interval: 7,
            type: .rounds,
            round: 1,
            serie: 1,
            totalSeries: 3,
            totalRounds: 4
        ), name: "Workout",
        state: .running
    )
    AthleteZoneWidgetAttributes.ContentState(
        workFlow: WorkFlow(
            interval: 6,
            type: .series,
            round: 1,
            serie: 1,
            totalSeries: 3,
            totalRounds: 4
        ), name: "Workout",
        state: .running
    )
    AthleteZoneWidgetAttributes.ContentState(
        workFlow: WorkFlow(
            interval: 5,
            type: .reset,
            round: 1,
            serie: 1,
            totalSeries: 3,
            totalRounds: 4
        ), name: "Workout",
        state: .running
    )
    AthleteZoneWidgetAttributes.ContentState(
        workFlow: WorkFlow(
            interval: 4,
            type: .preparation,
            round: 1,
            serie: 1,
            totalSeries: 3,
            totalRounds: 4
        ), name: "Workout",
        state: .running
    )
    AthleteZoneWidgetAttributes.ContentState(
        workFlow: WorkFlow(
            interval: 3,
            type: .preparation,
            round: 1,
            serie: 1,
            totalSeries: 3,
            totalRounds: 4
        ), name: "Workout",
        state: .running
    )
}
