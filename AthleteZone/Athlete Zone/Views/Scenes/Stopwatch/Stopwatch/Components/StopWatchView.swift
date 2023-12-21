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

    var onQuitTab: (() -> Void)?

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
                        .foregroundStyle(.white)

                    Divider()
                        .overlay(Color.white)
                    ScrollView {
                        ForEach(splitTimes.indices, id: \.self) { index in
                            HStack {
                                Text(LocalizedStringKey("\(index + 1). Split time:"))
                                    .frame(maxWidth: .infinity)
                                    .foregroundStyle(.white)

                                Text(splitTimes[index].toFormattedTime())
                                    .frame(maxWidth: .infinity)
                                    .foregroundStyle(.white)
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
                }
                .frame(maxWidth: .infinity, maxHeight: geo.size.height * 0.2)
            }
            .frame(maxHeight: .infinity)
            .padding([.leading, .trailing])
        }
        .background(Color(ComponentColor.darkBlue.rawValue))
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
                .foregroundColor(.buttonGreen)
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

extension StopWatchView {
    func onQuitTab(_ handler: @escaping () -> Void) -> StopWatchView {
        var new = self
        new.onQuitTab = handler
        return new
    }
}

#Preview {
    StopWatchView(
        interval: Binding.constant(0),
        state: Binding.constant(.ready),
        splitTimes: Binding.constant([1, 15, 34])
    )
}
