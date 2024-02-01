//
//  DynamicIslandExpandedView.swift
//  RunningWorkoutWidgetExtension
//
//  Created by Jan Prokorát on 27.09.2023.
//

import SwiftUI
import WidgetKit

struct DynamicIslandExpandedView: View {
    var workflow: WorkFlow
    var name: String
    var state: WorkFlowState

    var body: some View {
        VStack {
            HStack {
                DescriptionBar(text: name, color: .mainText)

                HStack {
                    Button(intent: LiveActivityActionIntent(state == .running ? .paused : .running)) {
                        Image(systemName: state == .running ? "pause.circle.fill" : "play.circle.fill")
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: 30, maxHeight: 30)
                            .padding(.leading, 2)
                            .foregroundColor(Color(workflow.color.rawValue))
                    }
                    .buttonStyle(.plain)

                    Button(intent: LiveActivityActionIntent(.quit)) {
                        Image(systemName: "stop.circle.fill")
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: 30, maxHeight: 30)
                            .padding(.trailing, 2)
                            .foregroundColor(Color(workflow.color.rawValue))
                    }
                    .buttonStyle(.plain)
                }
                .frame(alignment: .center)

                Text(workflow.label)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(Color(workflow.color.rawValue))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .font(.headline)
                    .background(
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(height: 30)
                                .foregroundColor(Color(ComponentColor.darkGrey.rawValue))
                        }
                    )
                    .frame(maxWidth: .infinity)
                    .frame(height: 30)
            }

            HStack {
                HStack {
                    VStack {
                        Spacer()

                        DescriptionBar(text: "Round \(workflow.round)/\(workflow.totalRounds)", color: .lightGreen)
                        DescriptionBar(text: "Exercise \(workflow.serie)/\(workflow.totalSeries)", color: .lightBlue)
                        Spacer()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                HStack {
                    VStack {
                        Spacer()

                        Text(workflow.interval.toFormattedTimeForWorkout())
                            .font(.title)
                            .foregroundColor(Color(workflow.color.rawValue))
                            .frame(maxWidth: .infinity, alignment: .center)
                            .background(
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .frame(height: 68)
                                        .foregroundColor(Color(ComponentColor.darkGrey.rawValue))
                                }
                            )

                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.top, -7)
        }
    }
}

#Preview {
    DynamicIslandExpandedView(
        workflow: WorkFlow(),
        name: "Title",
        state: .running
    )
    .previewContext(WidgetPreviewContext(family: .systemMedium))
}
