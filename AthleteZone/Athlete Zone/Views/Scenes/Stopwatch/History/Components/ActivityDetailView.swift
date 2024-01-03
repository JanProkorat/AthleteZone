//
//  ActivityDetailView.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 05.12.2023.
//

import SwiftUI

struct ActivityDetailView: View {
    @Binding var activity: StopWatch?

    var body: some View {
        DetailBaseView(title: activity?.name ?? "") {
            if let act = activity {
                VStack {
                    VStack(spacing: 7) {
                        DescriptionView(
                            property: LocalizationKey.start.localizedKey,
                            value: act.startDate.toFormattedString(),
                            color: ComponentColor.lightPink
                        )

                        DescriptionView(
                            property: LocalizationKey.end.localizedKey,
                            value: act.endDate.toFormattedString(),
                            color: ComponentColor.lightYellow
                        )
                    }

                    SplitTimesView(splitTimes: act.splitTimes)
                        .padding(.top)
                }
                .padding([.top, .bottom])
            }
        }
        .onCloseTab {
            activity = nil
        }
    }
}

#Preview {
    ActivityDetailView(
        activity: Binding.constant(StopWatch(
            startDate: Date(),
            endDate: Date(),
            splitTimes: [1, 10, 34, 86]
        ))
    )
}
