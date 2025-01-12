//
//  StopwatchRunView.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 13.03.2024.
//

import ComposableArchitecture
import SwiftUI

struct StopwatchRunView: View {
    @Bindable var store: StoreOf<StopwatchRunFeature>
    @Environment(\.scenePhase) var scenePhase: ScenePhase

    var body: some View {
        VStack {
            VStack(alignment: .center, spacing: 5) {
                TitleText(text: TimerType.stopWatch.rawValue, alignment: .center)
                    .padding(.top)
                GeometryReader { geo in
                    VStack {
                        CounterText(
                            text: store.timeElapsed.toFormattedTime(),
                            size: geo.size.height * 0.2
                        )
                        .padding([.leading, .trailing, .bottom])
                        .foregroundColor(
                            Color(store.isPaused ?
                                ComponentColor.lightYellow.rawValue : ComponentColor.lightPink.rawValue))

                        Text(LocalizationKey.splitTimes.localizedKey)
                            .font(.title2)
                            .foregroundStyle(.white)

                        Divider()
                            .overlay(Color.white)
                            .padding([.leading, .trailing])

                        ScrollView {
                            ForEach(store.splitTimes.indices, id: \.self) { index in
                                HStack {
                                    Text(LocalizedStringKey("\(index + 1). Split time:"))
                                        .frame(maxWidth: .infinity)
                                        .foregroundStyle(.white)

                                    Text(store.splitTimes[index].toFormattedTime())
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
                            .padding([.leading, .trailing])

                        HStack {
                            splitTimeButton(size: geo.size.height * 0.16)
                                .padding(.trailing, 25)
                            Button {
                                store.send(.pauseTapped)
                            } label: {
                                Image(!store.isPaused ? Icon.actionsPause.rawValue : Icon.start.rawValue)
                                    .resizable()
                                    .scaledToFill()
                                    .foregroundColor(.buttonGreen)
                                    .frame(maxWidth: geo.size.height * 0.16, maxHeight: geo.size.height * 0.16)
                            }
                            .padding(.leading, 25)
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
            if store.state == .running && oldValue == ScenePhase.active &&
                (newValue == ScenePhase.inactive || newValue == ScenePhase.background)
            {
                store.send(.pauseTapped)
            }
        }
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

    @ViewBuilder
    func splitTimeButton(size: CGFloat) -> some View {
        Button {
            store.send(.addSplitTime)
        } label: {
            Image(Icon.stopWatch.rawValue)
                .resizable()
                .scaledToFill()
                .foregroundColor(Color(
                    !store.isPaused ? ComponentColor.lightBlue.rawValue :
                        ComponentColor.grey.rawValue))
                .frame(maxWidth: size, maxHeight: size)
        }
        .disabled(store.isPaused)
    }
}

#Preview {
    StopwatchRunView(store: ComposableArchitecture.Store(initialState: StopwatchRunFeature.State(), reducer: {
        StopwatchRunFeature()
            ._printChanges()
    }))
}
