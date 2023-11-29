//
//  RunningWidgetView.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 24.09.2023.
//

import SwiftUI
import WidgetKit

struct WidgetMediumView: View {
    var workflow: WorkFlow
    var name: String

    var body: some View {
        HStack {
            HStack {
                VStack {
                    HeaderText(text: name)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading)

                    DescriptionBar(text: "Round \(workflow.round)/\(workflow.totalRounds)", color: .lightGreen)
                    DescriptionBar(text: "Exercise \(workflow.serie)/\(workflow.totalSeries)", color: .lightBlue)

                    Spacer()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            HStack {
                VStack {
                    Text(workflow.type.rawValue)
                        .font(.title3)
                        .foregroundColor(Color(workflow.color.rawValue))
                        .padding(.top, 5)

                    Spacer()

                    Text(workflow.interval.toFormattedTime())
                        .font(.title)
                        .foregroundColor(Color(workflow.color.rawValue))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top)
                        .background(
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .frame(height: 68)
                                    .foregroundColor(Color(ComponentColor.darkGrey.rawValue))
                                    .padding(.top, 13)
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

#Preview {
    WidgetMediumView(workflow: WorkFlow(), name: "Title")
        .previewContext(WidgetPreviewContext(family: .systemMedium))
}
