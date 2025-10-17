//
//  TimeTrackingView.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 04.03.2024.
//

import ComposableArchitecture
import SwiftUI

struct TimeTrackingView: View {
    @Bindable var store: StoreOf<TimeTrackingFeature>

    var body: some View {
        GeometryReader { geo in
            VStack {
                VStack(alignment: .center, spacing: 3) {
                    InformationPanel(
                        image: "clock.badge.questionmark",
                        size: geo.size.height * 0.45 * 0.2,
                        color: .lightBlue,
                        label: LocalizationKey.lastActivity,
                        text: store.displayedTypeLabel
                    )
                    .padding(.top, 6)

                    InformationPanel(
                        image: "play.circle",
                        size: geo.size.height * 0.45 * 0.2,
                        color: .lightPink,
                        label: LocalizationKey.trackedTime,
                        text: store.lastTrackedTime
                    )

                    switch store.displayedType {
                    case .stopWatch:
                        splitTimesView(splitTimes: store.lastActivity?.splitTimes ?? [])

                    case .timer:
                        recentTimerView(timers: store.lastTImer, height: geo.size.height)
                    }
                }
                .frame(height: geo.size.height * 0.67, alignment: .top)
                .frame(maxWidth: .infinity)

                Button {
                    store.send(.startTapped)
                } label: {
                    Image(Icon.start.rawValue)
                        .resizable()
                        .scaledToFill()
                        .foregroundColor(
                            store.isRunDisabled ? .grey :
                                Color(ComponentColor.action.rawValue))
                        .frame(maxWidth: geo.size.height * 0.3, maxHeight: geo.size.height * 0.3)
                }
                .disabled(store.isRunDisabled)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .fullScreenCover(item: $store.scope(
                state: \.destination?.runStopwatchSheet,
                action: \.destination.runStopwatchSheet
            )) { store in
                StopwatchRunView(store: store)
            }
            .fullScreenCover(item: $store.scope(state: \.destination?.runTimerSheet, action: \.destination.runTimerSheet)) { store in
                TimerRunView(store: store)
            }
        }
    }

    @ViewBuilder
    private func recentTimerView(timers: TimeInterval, height: CGFloat) -> some View {
        VStack {
            Text(LocalizationKey.startTime.localizedKey)
                .font(.title2)
                .foregroundStyle(.white)

            TimePicker(
                textColor: ComponentColor.lightPink,
                interval: $store.timerStartValue.sending(\.timerStartValueChanged)
            )
            .padding(.top)
        }
        .frame(maxHeight: .infinity)
        .padding(.top)
    }

    @ViewBuilder
    private func splitTimesView(splitTimes: [TimeInterval]) -> some View {
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
    }
}

#Preview {
    TimeTrackingView(store: ComposableArchitecture.Store(initialState: TimeTrackingFeature.State(), reducer: {
        TimeTrackingFeature()
    }))
}
