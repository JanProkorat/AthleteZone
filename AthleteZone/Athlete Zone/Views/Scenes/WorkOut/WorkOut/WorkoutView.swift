//
//  WorkoutView.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 22.02.2024.
//

import ComposableArchitecture
import SwiftUI

struct WorkoutView: View {
    @Bindable var store: StoreOf<WorkoutFeature>

    var buttons = [
        WorkOutButtonConfig(id: .work, image: "play.circle", color: .lightPink, type: .time),
        WorkOutButtonConfig(id: .rest, image: "pause.circle", color: .lightYellow, type: .time),
        WorkOutButtonConfig(id: .series, image: "forward.circle", color: .lightBlue, type: .number),
        WorkOutButtonConfig(id: .rounds, image: "repeat.circle", color: .lightGreen, type: .number),
        WorkOutButtonConfig(id: .reset, image: "clock.arrow.circlepath", color: .braun, type: .time)
    ]

    var body: some View {
        GeometryReader { geo in
            VStack {
                VStack(alignment: .center, spacing: 3) {
                    ForEach(buttons, id: \.id) { button in
                        Button {
                            store.send(.activitySelect(button.id))
                        } label: {
                            ActivityLabelView(
                                image: button.image,
                                size: geo.size.height * 0.45 * 0.2,
                                color: button.color,
                                type: button.id,
                                labelType: button.type,
                                interval: getProperty(for: button.id)
                            )
                        }
                    }
                }
                .frame(height: geo.size.height * 0.5, alignment: .top)
                .frame(maxWidth: .infinity)

                VStack(alignment: .center, spacing: 3) {
                    HStack(alignment: .center) {
                        CounterText(
                            text: store.timeOverview.toFormattedTime(),
                            size: geo.size.height * 0.2
                        )
                    }
                    .frame(maxWidth: .infinity, maxHeight: geo.size.height * 0.2)

                    Button {
                        store.send(.startTapped)
                    } label: {
                        Image(Icon.start.rawValue)
                            .resizable()
                            .scaledToFill()
                            .foregroundColor(store.isRunDisabled ? .grey : Color(ComponentColor.action.rawValue))
                            .frame(maxWidth: geo.size.height * 0.3, maxHeight: geo.size.height * 0.3)
                    }
                    .disabled(store.isRunDisabled)
                }
                .frame(height: geo.size.height * 0.47)
                .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .sheet(item: $store.scope(state: \.destination?.activitySheet, action: \.destination.activitySheet)) { store in
                ActivitySheetView(store: store)
                    .presentationDetents([.fraction(0.5)])
            }
            .sheet(item: $store.scope(state: \.destination?.saveSheet, action: \.destination.saveSheet)) { store in
                WorkoutEditView(store: store)
            }
            .fullScreenCover(item: $store.scope(state: \.destination?.runSheet, action: \.destination.runSheet)) { store in
                WorkoutRunView(store: store)
            }
        }
    }

    func getProperty(for activityType: ActivityType) -> Int {
        switch activityType {
        case .work:
            return store.work

        case .rest:
            return store.rest

        case .series:
            return store.series

        case .rounds:
            return store.rounds

        case .reset:
            return store.reset
        }
    }
}

#Preview {
    WorkoutView(store: ComposableArchitecture.Store(initialState: WorkoutFeature.State()) {
        WorkoutFeature()
            ._printChanges()
    })
}
