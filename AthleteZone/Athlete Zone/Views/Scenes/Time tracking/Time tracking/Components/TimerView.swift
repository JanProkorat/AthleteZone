//
//  TimerView.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 03.12.2023.
//

import SwiftUI

struct TimerView: View {
    @Binding var interval: TimeInterval
    var recent: [TimerDto]

    var onStartTap: (() -> Void)?
    var onRecentStartTap: ((_ value: TimeInterval) -> Void)?

    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .center, spacing: 0) {
                TimePicker(textColor: .braun, interval: $interval)
                    .frame(maxHeight: geo.size.height * 0.24)
                    .padding(.top)

                VStack {
                    Text(LocalizationKey.recent.localizedKey)
                        .font(.title2)
                        .foregroundStyle(.white)

                    Divider()
                        .overlay(Color.white)

                    List {
                        ForEach(recent) { recent in
                            HStack {
                                Text(recent.interval.toFormattedTimeForWorkout())
                                    .font(.title3)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(5)
                                    .padding(.leading)

                                Button {
                                    performAction(onRecentStartTap, value: recent.interval)
                                } label: {
                                    Image(Icon.start.rawValue)
                                        .resizable()
                                        .scaledToFill()
                                        .foregroundColor(Color(ComponentColor.action.rawValue))
                                        .frame(maxWidth: geo.size.height * 0.07, maxHeight: geo.size.height * 0.07)
                                }
                                .padding(5)
                                .padding(.trailing, 5)
                            }
                            .roundedBackground(cornerRadius: 0, color: .darkBlue, border: .menu, borderWidth: 3)
                            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        }
                    }
                    .listStyle(.plain)

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
                            .foregroundColor(Color(interval == 0 ? ComponentColor.grey.rawValue : ComponentColor.action.rawValue))
                            .frame(maxWidth: geo.size.height * 0.17, maxHeight: geo.size.height * 0.17)
                    }
                    .padding([.bottom], 5)
                    .disabled(interval == 0)
                }
                .frame(maxHeight: geo.size.height * 0.25)
            }
            .frame(maxHeight: .infinity)
            .padding([.leading, .trailing])
        }
    }
}

#Preview {
    TimerView(interval: Binding.constant(1), recent: [])
}

extension TimerView {
    func onStartTap(_ handler: @escaping () -> Void) -> TimerView {
        var new = self
        new.onStartTap = handler
        return new
    }

    func onRecentStartTap(_ handler: @escaping (_ value: TimeInterval) -> Void) -> TimerView {
        var new = self
        new.onRecentStartTap = handler
        return new
    }
}
