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
    var isFirstRunning: Bool
    var isLastRunning: Bool

    var onBackTap: (() -> Void)?
    var onForwardTap: (() -> Void)?

    var body: some View {
        VStack {
            Description(title: LocalizationKey.startTime.localizedKey, color: .lightGreen)

            HStack {
                Button {
                    performAction(onBackTap)
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(Color(ComponentColor.lightBlue.rawValue))
                }
                .buttonStyle(.plain)
                .disabled(isFirstRunning)

                Description(
                    title: "\(originalTime.toFormattedTimeForWorkout())",
                    color: ComponentColor.lightBlue
                )
                .padding([.leading, .trailing], 2)

                Button {
                    performAction(onForwardTap)
                } label: {
                    Image(systemName: "chevron.right")
                        .foregroundColor(Color(ComponentColor.lightBlue.rawValue))
                }
                .buttonStyle(.plain)
                .disabled(isLastRunning)
            }
            .roundedBackground(cornerRadius: 10, color: Color(ComponentColor.darkBlue.rawValue))
            .padding(.top, 1)

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

extension TimerTrackingTab {
    func onBackTap(_ handler: @escaping () -> Void) -> TimerTrackingTab {
        var new = self
        new.onBackTap = handler
        return new
    }

    func onForwardTap(_ handler: @escaping () -> Void) -> TimerTrackingTab {
        var new = self
        new.onForwardTap = handler
        return new
    }
}

#Preview {
    TimerTrackingTab(
        originalTime: 137,
        actionLabel: .work,
        timeElapsed: TimeInterval(98).toFormattedTimeForWorkout(),
        actionColor: .lightPink,
        isFirstRunning: false,
        isLastRunning: true
    )
}
