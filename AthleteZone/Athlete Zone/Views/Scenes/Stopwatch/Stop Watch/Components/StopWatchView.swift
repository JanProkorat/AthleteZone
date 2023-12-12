//
//  StopWatchView.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 03.12.2023.
//

import SwiftUI

struct StopWatchView: View {
    @Binding var interval: TimeInterval
    @Binding var state: WorkFlowState
    @Binding var splitTimes: [TimeInterval]

    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .center, spacing: 0) {
                CounterText(
                    text: interval.toFormattedTime(),
                    size: geo.size.height * 0.2
                )
                .padding([.top, .leading, .trailing, .bottom])
                .foregroundColor(Color(getColor()))

                VStack {
                    Text(LocalizationKey.splitTimes.localizedKey)
                        .font(.title2)
                    Divider()
                        .overlay(Color.white)
                    ScrollView {
                        ForEach(splitTimes.indices, id: \.self) { index in
                            HStack {
                                Text(LocalizedStringKey("\(index + 1). Split time:"))
                                    .frame(maxWidth: .infinity)

                                Text(splitTimes[index].toFormattedTime())
                                    .frame(maxWidth: .infinity)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, 5)
                        }
                    }
                    .frame(maxHeight: .infinity)

                    Divider()
                        .overlay(Color.white)
                }
                .frame(maxHeight: .infinity)
                .padding(.top)

                VStack {
                    HStack {
                        splitTimeButton(size: geo.size.height * 0.16)
                            .padding(.trailing, 25)
                        actionButton(size: geo.size.height * 0.16)
                            .padding(.leading, 25)
                    }

                    guitButton()
                }
                .frame(maxWidth: .infinity, maxHeight: geo.size.height * 0.25)
                .padding(.top)
            }
            .frame(maxHeight: .infinity)
            .padding([.leading, .trailing])
        }
    }

    @ViewBuilder
    func guitButton() -> some View {
        Button {
            state = .quit
        } label: {
            Text(state == .paused ? LocalizationKey.quitTracking.localizedKey : "")
                .font(.headline)
                .bold()
        }
        .padding(.top, 5)
        .frame(height: 15)
        .frame(maxWidth: .infinity, alignment: .center)
        .foregroundColor(Color(ComponentColor.mainText.rawValue))
    }

    @ViewBuilder
    func splitTimeButton(size: CGFloat) -> some View {
        Button {
            splitTimes.append(interval)
        } label: {
            Image(Icons.stopWatch.rawValue)
                .resizable()
                .scaledToFill()
                .foregroundColor(Color(
                    state == .running ? ComponentColor.lightBlue.rawValue :
                        ComponentColor.grey.rawValue))
                .frame(maxWidth: size, maxHeight: size)
        }
        .disabled(state != .running)
    }

    @ViewBuilder
    func actionButton(size: CGFloat) -> some View {
        Button {
            state = state == .running ? .paused : .running
        } label: {
            Image(state == .running ? Icons.actionsPause.rawValue : Icons.start.rawValue)
                .resizable()
                .scaledToFill()
                .foregroundColor(Color(ComponentColor.action.rawValue))
                .frame(maxWidth: size, maxHeight: size)
        }
    }

    func getColor() -> String {
        switch state {
        case .running:
            return ComponentColor.lightPink.rawValue

        case .paused:
            return ComponentColor.lightYellow.rawValue

        default:
            return ComponentColor.braun.rawValue
        }
    }
}

#Preview {
    StopWatchView(
        interval: Binding.constant(0),
        state: Binding.constant(.ready),
        splitTimes: Binding.constant([1, 15, 34])
    )
}
