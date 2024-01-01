//
//  ActivityDetailView.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 05.12.2023.
//

import SwiftUI

struct ActivityDetailView: View {
    var activity: StopWatch

    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color(ComponentColor.darkGrey.rawValue), lineWidth: 3)
                    .foregroundColor(Color(ComponentColor.darkGrey.rawValue))
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(Color(ComponentColor.darkBlue.rawValue))
                Text(activity.name)
                    .font(.title)
                    .foregroundColor(Color(ComponentColor.mainText.rawValue))
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding(.top, 20)
            .padding([.leading, .trailing], 10)
            .frame(maxHeight: 80)

            VStack(spacing: 7) {
                DescriptionView(
                    property: LocalizationKey.start.localizedKey,
                    value: activity.startDate.toFormattedString(),
                    color: ComponentColor.lightPink
                )

                DescriptionView(
                    property: LocalizationKey.end.localizedKey,
                    value: activity.endDate.toFormattedString(),
                    color: ComponentColor.lightYellow
                )
            }
            .padding([.top, .leading, .trailing])

            SplitTimesView(splitTimes: activity.splitTimes)
                .padding(.top)

            Spacer()
        }
        .background(Color(ComponentColor.darkBlue.rawValue))
        .environment(\.colorScheme, .dark)
    }
}

#Preview {
    ActivityDetailView(
        activity: StopWatch(
            startDate: Date(),
            endDate: Date(),
            splitTimes: [1, 10, 34, 86]
        )
    )
}
