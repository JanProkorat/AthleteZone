//
//  WorkoutTrackingView.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 23.05.2024.
//

import SwiftUI

struct WorkoutTrackingView: View {
    var flow: WorkFlow
    var isFirstRunning: Bool
    var isLastRunning: Bool

    var onBackTap: (() -> Void)?
    var onForwardTap: (() -> Void)?

    var body: some View {
        VStack {
            Description(
                title: "Round \(flow.round)/\(flow.totalRounds)",
                color: ComponentColor.lightGreen
            )

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
                    title: "Exercise \(flow.serie)/\(flow.totalSeries)",
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

            Text(LocalizedStringKey(flow.type.rawValue))
                .font(.headline)
                .padding(.top, 10)
                .frame(maxWidth: .infinity, alignment: .center)
                .foregroundStyle(.white)

            Text(flow.interval.toFormattedTimeForWorkout())
                .font(.title)
                .scaledToFill()
                .scaledToFit()
                .minimumScaleFactor(0.01)
                .lineLimit(1)
                .foregroundColor(Color(flow.color.rawValue))
                .padding(.top, 2)
        }
        .padding(.top, 15)
        .ignoresSafeArea(.all, edges: .bottom)
    }
}

extension WorkoutTrackingView {
    func onBackTap(_ handler: @escaping () -> Void) -> WorkoutTrackingView {
        var new = self
        new.onBackTap = handler
        return new
    }

    func onForwardTap(_ handler: @escaping () -> Void) -> WorkoutTrackingView {
        var new = self
        new.onForwardTap = handler
        return new
    }
}

#Preview {
    WorkoutTrackingView(
        flow: WorkFlow(interval: 30, type: .work, round: 3, serie: 5, totalSeries: 5, totalRounds: 10),
        isFirstRunning: true,
        isLastRunning: false
    )
}
