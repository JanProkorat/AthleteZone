//
//  TrainingRunView.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 01.03.2024.
//

import ComposableArchitecture
import SwiftUI

struct TrainingRunView: View {
    @Bindable var store: StoreOf<TrainingRunFeature>
    @Environment(\.scenePhase) var scenePhase: ScenePhase

    var body: some View {
        VStack {
            VStack(alignment: .center, spacing: 5) {
                TitleText(text: store.name, alignment: .center)

                Menu {
                    ForEach(store.workouts, id: \.id) { workout in
                        Button {
                            store.send(.setWorkflow(workout))
                            store.send(.stateChanged(.ready))
                        } label: {
                            HStack {
                                Text(workout.name)
                                if workout.id == store.currentWorkout?.id {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(Color(ComponentColor.lightYellow.rawValue))
                                }
                            }
                        }
                    }
                } label: {
                    HStack(alignment: .center) {
                        ZStack(alignment: .trailing) {
                            TitleText(text: store.currentWorkout?.name ?? "", alignment: .center)
                            Image(Icon.arrowDown.rawValue)
                                .resizable()
                                .scaledToFill()
                                .foregroundColor(Color(ComponentColor.mainText.rawValue))
                                .frame(maxWidth: 35, maxHeight: 30)
                                .padding(.trailing, 20)
                        }
                    }
                    .frame(height: 50)
                    .roundedBackground(cornerRadius: 20)
                }

                if let flow = store.currentActivity {
                    DescriptionLabel(title: "Round \(flow.round)/\(flow.totalRounds)",
                                     color: ComponentColor.lightGreen)
                        .padding(.top, 5)
                        .padding([.leading, .trailing], 7)
                    DescriptionLabel(title: "Exercise \(flow.serie)/\(flow.totalSeries)",
                                     color: ComponentColor.lightBlue)
                        .padding([.leading, .trailing], 7)

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
                                .padding(.top, store.state == .finished ? 3 : 0)

                                IconButton(
                                    id: "start",
                                    image: store.state.getIcon().rawValue,
                                    color: ComponentColor.action,
                                    width: geo.size.height * 0.2,
                                    height: geo.size.height * 0.2
                                )
                                .onTab {
                                    store.send(.pauseTapped)
                                }
                                .padding([.leading, .trailing])
                                .padding(.top, store.state == .finished ? -3 : 0)

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
                                .padding(.top, store.state == .finished ? 3 : 0)
                            }

                            Button {
                                store.send(.quitTapped)
                            } label: {
                                cancelButton(height: geo.size.height * 0.08)
                            }
                            .padding(.top, store.state == .finished ? 19 : 16)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .padding([.leading, .trailing], 5)
        }
        .background(Color(ComponentColor.darkBlue.rawValue))
        .environment(\.colorScheme, .dark)
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
    TrainingRunView(store: ComposableArchitecture.Store(
        initialState: TrainingRunFeature.State(
            name: "name",
            workouts: [
                WorkoutDto(
                    id: UUID(),
                    name: "Prvni",
                    work: 2,
                    rest: 2,
                    series: 2,
                    rounds: 2,
                    reset: 30,
                    createdDate: Date(),
                    workoutLength: 50
                ),
                WorkoutDto(
                    id: UUID(),
                    name: "Prvni",
                    work: 2,
                    rest: 2,
                    series: 2,
                    rounds: 2,
                    reset: 30,
                    createdDate: Date(),
                    workoutLength: 50
                ),
                WorkoutDto(
                    id: UUID(),
                    name: "Prvni",
                    work: 2,
                    rest: 2,
                    series: 2,
                    rounds: 2,
                    reset: 30,
                    createdDate: Date(),
                    workoutLength: 50
                ),
                WorkoutDto(
                    id: UUID(),
                    name: "Prvni",
                    work: 2,
                    rest: 2,
                    series: 2,
                    rounds: 2,
                    reset: 30,
                    createdDate: Date(),
                    workoutLength: 50
                ),
                WorkoutDto(
                    id: UUID(),
                    name: "Prvni",
                    work: 2,
                    rest: 2,
                    series: 2,
                    rounds: 2,
                    reset: 30,
                    createdDate: Date(),
                    workoutLength: 50
                ),
                WorkoutDto(
                    id: UUID(),
                    name: "Prvni",
                    work: 2,
                    rest: 2,
                    series: 2,
                    rounds: 2,
                    reset: 30,
                    createdDate: Date(),
                    workoutLength: 50
                )
            ]
        ), reducer: {
            TrainingRunFeature()
                ._printChanges()
        }
    ))
}
