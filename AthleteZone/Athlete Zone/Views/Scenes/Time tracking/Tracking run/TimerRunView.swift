//
//  TimerRunView.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 13.03.2024.
//

import ComposableArchitecture
import SwiftUI

struct TimerRunView: View {
    @Bindable var store: StoreOf<TimerRunFeature>
    @Environment(\.scenePhase) var scenePhase: ScenePhase

    var body: some View {
        VStack {
            VStack(alignment: .center, spacing: 5) {
                TitleText(text: TimerType.timer.rawValue, alignment: .center)
                    .padding(.top)
                DescriptionLabel(title: "Original start time: \(store.originalInterval.toFormattedTimeForTimer())",
                                 color: ComponentColor.lightGreen)
                    .padding([.leading, .trailing], 5)
                    .padding(.top)

                GeometryReader { geo in
                    VStack {
                        ZStack {
                            CircularProgressBar(
                                color: store.isPaused ? ComponentColor.lightYellow : ComponentColor.lightPink,
                                progress: Double(store.originalInterval - store.interval) / Double(store.originalInterval))
                            CounterText(text: store.interval.toFormattedTimeForWorkout(), size: geo.size.height * 0.14)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)

                        HStack {
                            resetButton(size: geo.size.height * 0.13)
                                .padding(.trailing, 25)
                            Button {
                                store.send(.pauseTapped)
                            } label: {
                                Image(store.state.state == .running ? Icon.actionsPause.rawValue : Icon.start.rawValue)
                                    .resizable()
                                    .scaledToFill()
                                    .foregroundColor(store.state.state == .finished ? .grey : .buttonGreen)
                                    .frame(maxWidth: geo.size.height * 0.16, maxHeight: geo.size.height * 0.16)
                            }
                            .padding(.leading, 25)
                            .disabled(store.state.state == .finished)
                        }
                        .frame(maxWidth: .infinity, maxHeight: geo.size.height * 0.2)

                        Button {
                            store.send(.quitTapped)
                        } label: {
                            quitButton(height: geo.size.height * 0.08)
                        }
                    }
                    .frame(maxHeight: .infinity)
                    .padding(.top)
                }
            }
        }
        .background(Color(ComponentColor.darkBlue.rawValue))
        .environment(\.colorScheme, .dark)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onChange(of: store.state) { _, newValue in
            switch newValue {
            case .running:
                UIApplication.shared.isIdleTimerDisabled = true

            default:
                UIApplication.shared.isIdleTimerDisabled = false
            }
        }
        .onChange(of: scenePhase) { oldValue, newValue in
            if store.backgroundRunAllowed {
                return
            }
            if oldValue == ScenePhase.active && (newValue == ScenePhase.inactive || newValue == ScenePhase.background) {
                store.send(.pauseTapped)
            }
        }
    }

    @ViewBuilder
    private func resetButton(size: CGFloat) -> some View {
        Button {
            store.send(.resetTapped)
        } label: {
            Image(systemName: "clock.arrow.circlepath")
                .resizable()
                .scaledToFill()
                .foregroundColor(Color(ComponentColor.braun.rawValue))
                .frame(maxWidth: size, maxHeight: size)
        }
        .disabled(store.isPaused)
    }

    @ViewBuilder
    private func quitButton(height: CGFloat) -> some View {
        HStack {
            Text(LocalizationKey.quitWorkout.localizedKey)
                .font(.headline)
                .foregroundColor(.lightPink)
                .bold()
                .padding([.leading, .trailing], 20)
        }
        .frame(height: height)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .frame(height: height)
                .frame(maxWidth: .infinity)
                .foregroundColor(Color(ComponentColor.menu.rawValue))
        )
        .padding([.top, .bottom], 3)
    }
}

#Preview {
    TimerRunView(store: ComposableArchitecture.Store(initialState: TimerRunFeature.State(interval: 18), reducer: {
        TimerRunFeature()
            ._printChanges()
    }))
}
