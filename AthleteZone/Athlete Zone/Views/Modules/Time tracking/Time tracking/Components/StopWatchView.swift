//
//  StopWatchView.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 03.12.2023.
//

import SwiftUI

struct StopWatchView: View {
    var interval: TimeInterval
    var splitTimes: [TimeInterval]

    var onStartTap: (() -> Void)?

    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .center, spacing: 0) {
                TitleText(text: LocalizationKey.lastActivity.rawValue, alignment: .center)
                CounterText(
                    text: interval.toFormattedTime(),
                    size: geo.size.height * 0.2
                )
                .padding([.top, .leading, .trailing, .bottom])
                .foregroundColor(Color(ComponentColor.braun.rawValue))

                VStack {
                    Text(LocalizationKey.splitTimes.localizedKey)
                        .font(.title2)
                        .foregroundStyle(.white)

                    Divider()
                        .overlay(Color.white)

                    ScrollView {
                        if splitTimes.isEmpty {
                            Text(LocalizationKey.noSplitTimes.localizedKey)
                                .font(.headline)
                                .bold()
                                .padding(.top, 20)
                                .foregroundStyle(.white)
                        }

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
                    Text(LocalizationKey.newActivity.localizedKey)
                        .font(.title2)
                        .foregroundStyle(.white)
                        .padding(.top)
                        .padding(.bottom, -5)

                    Button {
                        performAction(onStartTap)
                    } label: {
                        Image(Icon.start.rawValue)
                            .resizable()
                            .scaledToFill()
                            .foregroundColor(Color(ComponentColor.action.rawValue))
                            .frame(maxWidth: geo.size.height * 0.17, maxHeight: geo.size.height * 0.17)
                    }
                    .padding([.bottom], 5)
                }
                .frame(maxHeight: geo.size.height * 0.25)
            }
            .frame(maxHeight: .infinity)
            .padding([.leading, .trailing])
        }
    }
}

#Preview {
    StopWatchView(interval: 381, splitTimes: [1, 15, 34])
}

extension StopWatchView {
    func onStartTap(_ handler: @escaping () -> Void) -> StopWatchView {
        var new = self
        new.onStartTap = handler
        return new
    }
}
