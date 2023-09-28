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

    var body: some View {
        VStack {
            HStack {
                Text(name)
                    .font(.headline)
                    .frame(maxWidth: .infinity)

                Text(workflow.type.rawValue)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(Color(workflow.color.rawValue))
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

                        Text(workflow.interval.toFormattedValue(type: .time))
                            .font(.title)
                            .foregroundColor(Color(workflow.color.rawValue))
                            .frame(maxWidth: .infinity, alignment: .center)
                            .background(
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .frame(height: 68)
                                        .foregroundColor(Color(Background.listItemBackground.rawValue))
                                }
                            )

                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

#Preview {
    DynamicIslandExpandedView(workflow: WorkFlow(), name: "Title")
        .previewContext(WidgetPreviewContext(family: .systemMedium))
}
