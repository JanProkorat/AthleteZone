//
//  AthleteZoneWidgetsLiveActivity.swift
//  AthleteZoneWidgets
//
//  Created by Jan Prokorát on 28.09.2023.
//

import ActivityKit
import SwiftUI
import WidgetKit

struct AthleteZoneWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: AthleteZoneWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            HStack {
                Image(systemName: context.state.workFlow.icon)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: 30, maxHeight: 30)
                    .padding(.leading, 10)
                    .padding([.top, .bottom], 2)
                    .foregroundColor(Color(context.state.workFlow.color.rawValue))

                Text(context.state.workFlow.type.rawValue)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(Color(context.state.workFlow.color.rawValue))
                    .font(.title)
                    .padding(.leading, 5)

                Text(context.state.workFlow.interval.toFormattedTime())
//                    .frame(maxWidth: .infinity)
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
                    DynamicIslandExpandedView(workflow: context.state.workFlow, name: context.state.name)
                }
            } compactLeading: {
                HStack {
                    Image(systemName: context.state.workFlow.icon)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: 15, maxHeight: 15)
                        .foregroundColor(Color(context.state.workFlow.color.rawValue))

                    Text(context.state.workFlow.label)
                        .font(.subheadline)
                        .foregroundStyle(Color(context.state.workFlow.color.rawValue))
                }
            } compactTrailing: {
                Text(context.state.workFlow.interval.toFormattedTime())
                    .font(.subheadline)
                    .foregroundStyle(Color(context.state.workFlow.color.rawValue))
            } minimal: {
                Image(systemName: context.state.workFlow.icon)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: 30, maxHeight: 30)
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
        ), name: "Workout"
    )
    AthleteZoneWidgetAttributes.ContentState(
        workFlow: WorkFlow(
            interval: 9,
            type: .preparation,
            round: 1,
            serie: 1,
            totalSeries: 3,
            totalRounds: 4
        ), name: "Workout"
    )
    AthleteZoneWidgetAttributes.ContentState(
        workFlow: WorkFlow(
            interval: 8,
            type: .preparation,
            round: 1,
            serie: 1,
            totalSeries: 3,
            totalRounds: 4
        ), name: "Workout"
    )
    AthleteZoneWidgetAttributes.ContentState(
        workFlow: WorkFlow(
            interval: 7,
            type: .preparation,
            round: 1,
            serie: 1,
            totalSeries: 3,
            totalRounds: 4
        ), name: "Workout"
    )
    AthleteZoneWidgetAttributes.ContentState(
        workFlow: WorkFlow(
            interval: 6,
            type: .preparation,
            round: 1,
            serie: 1,
            totalSeries: 3,
            totalRounds: 4
        ), name: "Workout"
    )
    AthleteZoneWidgetAttributes.ContentState(
        workFlow: WorkFlow(
            interval: 5,
            type: .preparation,
            round: 1,
            serie: 1,
            totalSeries: 3,
            totalRounds: 4
        ), name: "Workout"
    )
    AthleteZoneWidgetAttributes.ContentState(
        workFlow: WorkFlow(
            interval: 4,
            type: .preparation,
            round: 1,
            serie: 1,
            totalSeries: 3,
            totalRounds: 4
        ), name: "Workout"
    )
    AthleteZoneWidgetAttributes.ContentState(
        workFlow: WorkFlow(
            interval: 3,
            type: .preparation,
            round: 1,
            serie: 1,
            totalSeries: 3,
            totalRounds: 4
        ), name: "Workout"
    )
}
