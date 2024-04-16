//
//  WorkoutRunView.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 26.02.2024.
//

import ComposableArchitecture
import SwiftUI

struct WorkoutRunView: View {
    @Bindable var store: StoreOf<WorkoutRunFeature>
    @Environment(\.scenePhase) var scenePhase: ScenePhase

    var body: some View {
        VStack {
            VStack(alignment: .center, spacing: 5) {
                TitleText(text: store.name, alignment: .center)
                if let flow = store.currentActivity {
                    DescriptionLabel(title: "Round \(flow.round)/\(flow.totalRounds)",
                                     color: ComponentColor.lightGreen)
                        .padding(.top, 5)
                    DescriptionLabel(title: "Exercise \(flow.serie)/\(flow.totalSeries)",
                                     color: ComponentColor.lightBlue)

                    Text(LocalizedStringKey(flow.type.rawValue))
                        .font(.headline)
                        .bold()
                        .padding(.top, 10)
                        .frame(maxWidth: .infinity, alignment: .center)

                    GeometryReader { geo in
                        VStack(spacing: 0) {
                            ZStack {
                                CircularProgressBar(color: flow.color, progress: flow.getProgress())
                                CounterText(text: flow.interval.toFormattedTimeForWorkout(), size: geo.size.height * 0.14)
                            }
                            .frame(maxWidth: .infinity)

                            HStack(alignment: .center) {
                                IconButton(
                                    id: "back",
                                    image: Icon.forward.rawValue,
                                    color: store.currentFlowIndex == 0 ? ComponentColor.grey : ComponentColor.action,
                                    width: geo.size.height * 0.13,
                                    height: geo.size.height * 0.13,
                                    reversed: true
                                )
                                .onTab {
                                    store.send(.backTapped)
                                }
                                .disabled(store.currentFlowIndex == 0)

                                IconButton(
                                    id: "start",
                                    image: store.state == .running ? Icon.actionsPause.rawValue : Icon.start.rawValue,
                                    color: ComponentColor.action,
                                    width: geo.size.height * 0.2,
                                    height: geo.size.height * 0.2
                                )
                                .onTab {
                                    store.send(.pauseTapped)
                                }
                                .padding([.leading, .trailing])

                                IconButton(
                                    id: "forward",
                                    image: Icon.forward.rawValue,
                                    color: store.isLastRunning ? ComponentColor.grey : ComponentColor.action,
                                    width: geo.size.height * 0.13,
                                    height: geo.size.height * 0.13
                                )
                                .onTab {
                                    store.send(.forwardTapped)
                                }
                                .disabled(store.isLastRunning)
                            }

                            Button {
                                store.send(.quitTapped)
                            } label: {
                                cancelButton(height: geo.size.height * 0.08)
                            }
                            .padding(.top)
                        }
                        .frame(maxWidth: .infinity)
                    }
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
            if oldValue == ScenePhase.active && (newValue == ScenePhase.inactive || newValue == ScenePhase.background) {
                store.send(.pauseTapped)
            }
        }
    }

    @ViewBuilder
    private func cancelButton(height: CGFloat) -> some View {
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
    let store = ComposableArchitecture.Store(
        initialState: WorkoutRunFeature.State(
            name: "Test",
            work: 30,
            rest: 60,
            series: 5,
            rounds: 3,
            reset: 60
        ),
        reducer: {
            WorkoutRunFeature()
                ._printChanges()
        }
    )
    store.send(.onAppear)
    return WorkoutRunView(store: store)
}
