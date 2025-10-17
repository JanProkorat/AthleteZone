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
                DescriptionLabel(title: LocalizationKey.stopWatch.localizedKey, color: ComponentColor.lightGreen)
                    .padding(.top)

                Text(LocalizedStringKey(store.state.rawValue))
                    .font(.headline)
                    .bold()
                    .padding(.top, 10)
                    .frame(maxWidth: .infinity, alignment: .center)

                GeometryReader { geo in
                    VStack {
                        CounterText(
                            text: store.timeElapsed.toFormattedTime(showSubSeconds: false),
                            size: geo.size.height * 0.15
                        )
                        .padding(.bottom)
                        .foregroundColor(
                            Color(store.isPaused ?
                                ComponentColor.lightYellow.rawValue : ComponentColor.lightPink.rawValue))

                        Text(LocalizationKey.splitTimes.localizedKey)
                            .font(.title2)
                            .foregroundStyle(.white)

                        Divider()
                            .overlay(Color.white)

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

                        HStack {
                            splitTimeButton(size: geo.size.height * 0.16)
                                .padding(.trailing, 25)
                            Button {
                                store.send(.pauseTapped)
                            } label: {
                                Image(getButtonIcon(store.state).rawValue)
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
            .padding([.leading, .trailing], 5)
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
                    !store.isSplitButtonDisabled ? ComponentColor.lightBlue.rawValue :
                        ComponentColor.grey.rawValue))
                .frame(maxWidth: size, maxHeight: size)
        }
        .disabled(store.isSplitButtonDisabled)
    }

    func getButtonIcon(_ state: WorkFlowState) -> Icon {
        switch state {
        case .preparation, .running:
            return Icon.actionsPause

        case .paused, .ready, .finished, .quit:
            return Icon.start
        }
    }
}

#Preview {
    StopwatchRunView(store: ComposableArchitecture.Store(initialState: StopwatchRunFeature.State(), reducer: {
        StopwatchRunFeature()
            ._printChanges()
    }))
}
