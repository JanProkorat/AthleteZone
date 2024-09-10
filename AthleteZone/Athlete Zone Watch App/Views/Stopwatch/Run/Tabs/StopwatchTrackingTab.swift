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
    var isFirstRunning: Bool
    var isLastRunning: Bool

    var onAddSplitTimeTab: (() -> Void)?
    var onBackTap: (() -> Void)?
    var onForwardTap: (() -> Void)?

    var body: some View {
        VStack {
            Description(title: LocalizationKey.latestSplitTime.localizedKey, color: .lightGreen)

            HStack {
                Button {
                    performAction(onBackTap)
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(Color(ComponentColor.lightBlue.rawValue))
                }
                .buttonStyle(.plain)
                .disabled(isFirstRunning)

                description(title: splitTime?.toFormattedTime() ?? "_ _ / _ _")
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

    @ViewBuilder
    func description(title: String) -> some View {
        HStack {
            Text(title)
                .frame(maxWidth: .infinity)
                .font(.headline)
                .foregroundColor(
                    Color(ComponentColor.lightBlue.rawValue))
                .frame(height: 30)

            Button {
                performAction(onAddSplitTimeTab)
            } label: {
                Image(systemName: "plus")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Color(
                        state == .running ? ComponentColor.lightBlue.rawValue :
                            ComponentColor.grey.rawValue))
                    .frame(maxWidth: 15, maxHeight: 15)
            }
            .disabled(state == .paused || state == .preparation)
            .padding(.trailing, 15)
            .buttonStyle(PlainButtonStyle())
        }
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .frame(height: 30)
                    .foregroundColor(Color(ComponentColor.darkGrey.rawValue))
            }
        )
        .frame(minWidth: 0, maxWidth: .infinity)
    }
}

extension StopwatchTrackingTab {
    func onAddSplitTimeTab(_ handler: @escaping () -> Void) -> StopwatchTrackingTab {
        var new = self
        new.onAddSplitTimeTab = handler
        return new
    }

    func onBackTap(_ handler: @escaping () -> Void) -> StopwatchTrackingTab {
        var new = self
        new.onBackTap = handler
        return new
    }

    func onForwardTap(_ handler: @escaping () -> Void) -> StopwatchTrackingTab {
        var new = self
        new.onForwardTap = handler
        return new
    }
}

#Preview {
    StopwatchTrackingTab(
        timeElapsed: 123.43.toFormattedTime(),
        state: .preparation,
        actionLabel: .work,
        actionColor: .lightPink,
        isFirstRunning: false,
        isLastRunning: true
    )
}
