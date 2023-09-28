//
//  RunningWorkoutWidgetLiveActivity.swift
//  RunningWorkoutWidget
//
//  Created by Jan Prokorát on 05.08.2023.
//

import ActivityKit
import SwiftUI
import WidgetKit

struct RunningWorkoutWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: RunningWorkoutWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            HStack {
                Text(context.state.workFlow.type.rawValue)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(Color(context.state.workFlow.color.rawValue))
                    .font(.title)

                Text(context.state.workFlow.interval.toFormattedTime())
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(Color(context.state.workFlow.color.rawValue))
                    .font(.title)
            }
            .activityBackgroundTint(Color(Background.background.rawValue))
            .activitySystemActionForegroundColor(Color.white)
//            .background(Color(Background.background.rawValue))
            .frame(maxWidth: .infinity, maxHeight: .infinity)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.bottom) {
                    DynamicIslandExpandedView(workflow: context.state.workFlow, name: context.state.name)
                }
            } compactLeading: {
                Text(context.state.workFlow.type.rawValue)
                    .font(.headline)
                    .foregroundStyle(Color(context.state.workFlow.color.rawValue))
                    .padding(.leading, 2)
            } compactTrailing: {
                Text(context.state.workFlow.interval.toFormattedTime())
                    .font(.headline)
                    .foregroundStyle(Color(context.state.workFlow.color.rawValue))
            } minimal: {
                Text(context.state.workFlow.interval.toFormattedTime())
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

struct RunningWorkoutWidgetLiveActivity_Previews: PreviewProvider {
    static let attributes = RunningWorkoutWidgetAttributes()
    static let contentState = RunningWorkoutWidgetAttributes.ContentState(workFlow: WorkFlow(), name: "Workout")

    static var previews: some View {
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.compact))
            .previewDisplayName("Island Compact")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.expanded))
            .previewDisplayName("Island Expanded")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.minimal))
            .previewDisplayName("Minimal")
        attributes
            .previewContext(contentState, viewKind: .content)
            .previewDisplayName("Notification")
    }
}
