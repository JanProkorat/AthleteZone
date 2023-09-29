//
//  WidgetLargeView.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 24.09.2023.
//

import SwiftUI
import WidgetKit

struct WidgetLargeView: View {
    var workflow: WorkFlow
    var name: String

    var body: some View {
        VStack {
            HeaderText(text: name)
                .font(.largeTitle)
                .frame(maxWidth: .infinity)

            DescriptionBar(text: "Round \(workflow.round)/\(workflow.totalRounds)", color: .lightGreen)
            DescriptionBar(text: "Exercise \(workflow.serie)/\(workflow.totalSeries)", color: .lightBlue)
                .padding(.top, 5)

            ZStack {
                CircularProgressBar(
                    color: workflow.color,
                    progress: workflow.getProgress(),
                    lineWidth: 7
                )

                VStack {
                    Text(LocalizedStringKey(workflow.type.rawValue))
                        .font(.title2)
                        .padding(.top, 5)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(Color(workflow.color.rawValue))

                    Text(workflow.interval.toFormattedTime())
                        .font(.title)
                        .foregroundColor(Color(workflow.color.rawValue))
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }

            Spacer()
        }
        .background(Color(Background.background.rawValue))
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    WidgetLargeView(workflow: WorkFlow(), name: "First workout")
        .previewContext(WidgetPreviewContext(family: .systemMedium))
}
