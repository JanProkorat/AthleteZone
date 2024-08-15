//
//  StopwatchTrackingTab.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 05.07.2024.
//

import SwiftUI

struct StopwatchTrackingTab: View {
    var timeElapsed: String
    var splitTime: TimeInterval?
    var state: WorkFlowState
    var actionLabel: LocalizationKey
    var actionColor: ComponentColor

    var onAddSplitTimeTab: (() -> Void)?

    var body: some View {
        VStack {
            Description(
                title: "Latest split time",
                color: .lightGreen
            )

            HStack {
                description(
                    title: splitTime?.toFormattedTime() ?? "_ _ / _ _"
                )
                .padding(.trailing, 3)

                Button {
                    performAction(onAddSplitTimeTab)
                } label: {
                    Image(systemName: "plus")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Color(
                            state == .running ? ComponentColor.lightBlue.rawValue :
                                ComponentColor.grey.rawValue))
                        .frame(maxWidth: 20, maxHeight: 20)
                        .background(
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(Color(ComponentColor.darkGrey.rawValue))
                            }
                        )
                }
                .disabled(state == .paused || state == .preparation)
                .buttonStyle(PlainButtonStyle())
                .padding(.trailing, 5)
            }
            .frame(maxWidth: .infinity)

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

    @ViewBuilder
    func description(title: String) -> some View {
        Text(title)
            .frame(maxWidth: .infinity)
            .font(.headline)
            .foregroundColor(
                Color(ComponentColor.lightBlue.rawValue))
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(height: 30)
                        .foregroundColor(Color(ComponentColor.darkGrey.rawValue))
                }
            )
            .frame(minWidth: 0, maxWidth: .infinity)
            .frame(height: 30)
    }
}

extension StopwatchTrackingTab {
    func onAddSplitTimeTab(_ handler: @escaping () -> Void) -> StopwatchTrackingTab {
        var new = self
        new.onAddSplitTimeTab = handler
        return new
    }
}

#Preview {
    StopwatchTrackingTab(
        timeElapsed: 123.43.toFormattedTime(),
        state: .preparation,
        actionLabel: .go,
        actionColor: .lightPink
    )
}
