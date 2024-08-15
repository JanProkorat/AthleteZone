//
//  TimerTrackingTab.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 16.07.2024.
//

import SwiftUI

struct TimerTrackingTab: View {
    var originalTime: TimeInterval
    var actionLabel: LocalizationKey
    var timeElapsed: String
    var actionColor: ComponentColor

    var body: some View {
        VStack {
            Description(
                title: "Start time",
                color: .lightGreen
            )

            Description(
                title: "\(originalTime.toFormattedTimeForWorkout())",
                color: .lightBlue
            )

            Text(actionLabel.localizedKey)
                .font(.headline)
                .padding(.top, 10)
                .frame(maxWidth: .infinity, alignment: .center)

            Text(timeElapsed)
                .font(Font.monospacedDigit(.title2.weight(.light))())
                .scaledToFill()
                .scaledToFit()
                .minimumScaleFactor(0.01)
                .lineLimit(1)
                .foregroundColor(Color(actionColor.rawValue))
                .padding(.top, 2)
        }
        .padding(.top, 15)
    }
}

#Preview {
    TimerTrackingTab(
        originalTime: 137,
        actionLabel: .go,
        timeElapsed: TimeInterval(98).toFormattedTimeForWorkout(),
        actionColor: .lightPink
    )
}
