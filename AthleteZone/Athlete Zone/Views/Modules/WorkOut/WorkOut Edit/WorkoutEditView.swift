//
//  WorkoutEditView.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 23.02.2024.
//

import ComposableArchitecture
import SwiftUI

struct WorkoutEditView: View {
    @Bindable var store: StoreOf<WorkoutEditFeature>

    var buttons = [
        WorkOutButtonConfig(id: .work, image: "play.circle", color: .lightPink, type: .time),
        WorkOutButtonConfig(id: .rest, image: "pause.circle", color: .lightYellow, type: .time),
        WorkOutButtonConfig(id: .series, image: "forward.circle", color: .lightBlue, type: .number),
        WorkOutButtonConfig(id: .rounds, image: "repeat.circle", color: .lightGreen, type: .number),
        WorkOutButtonConfig(id: .reset, image: "clock.arrow.circlepath", color: .braun, type: .time)
    ]

    var body: some View {
        GeometryReader { geometry in
            VStack {
                TitleText(text: store.headerText.rawValue, alignment: .center)
                    .padding([.leading, .trailing], 10)
                    .frame(maxWidth: .infinity)
                    .frame(height: geometry.size.height * 0.08)

                VStack {
                    VStack(alignment: .leading, spacing: 5) {
                        EditField(label: LocalizationKey.name, labelSize: 23, color: ComponentColor.mainText) {
                            TextInput(text: $store.name.sending(\.nameUpdated))
                        }
                        .padding([.top, .bottom])
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .roundedBackground(cornerRadius: 20)

                    VStack(alignment: .center, spacing: 3) {
                        ForEach(buttons, id: \.id) { button in
                            Button {
                                store.send(.activitySelect(button.id))
                            } label: {
                                ActivityLabelView(
                                    image: button.image,
                                    size: geometry.size.height * 0.45 * 0.17,
                                    color: button.color,
                                    type: button.id,
                                    labelType: button.type,
                                    interval: getProperty(for: button.id)
                                )
                            }
                        }
                    }
                    .frame(height: geometry.size.height * 0.5, alignment: .top)
                    .frame(maxWidth: .infinity)
                    .padding(.top)

                    CounterText(
                        text: store.timeOverview.toFormattedTime(),
                        size: geometry.size.height * 0.1
                    )
                    .padding(.top, -50)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)

                VStack(spacing: 5) {
                    ActionButton(content: {
                        ActionView(
                            text: LocalizationKey.save,
                            color: store.saveDisabled ? .grey : .lightGreen,
                            backgoundColor: ComponentColor.menu.rawValue,
                            image: Icon.check.rawValue,
                            height: 60,
                            cornerRadius: nil
                        )
                    })
                    .onTab { store.send(.saveTapped) }
                    .disabled(store.saveDisabled)

                    ActionButton(content: {
                        ActionView(
                            text: LocalizationKey.cancel,
                            color: ComponentColor.lightPink,
                            backgoundColor: ComponentColor.menu.rawValue,
                            image: Icon.clear.rawValue,
                            height: 60,
                            cornerRadius: nil
                        )
                    })
                    .onTab { store.send(.cancelTapped) }
                }
                .frame(maxWidth: .infinity)
                .frame(maxHeight: geometry.size.height * 0.2)
            }
            .padding([.leading, .trailing], 10)
        }
        .background(Color(ComponentColor.darkBlue.rawValue))
        .environment(\.colorScheme, .dark)
        .ignoresSafeArea(.keyboard, edges: [.bottom])
        .sheet(isPresented: $store.isActivitySheetVisible.sending(\.activitySheetVisibilityChanged), content: {
            DetailBaseView(title: LocalizedStringKey(store.selectedType!.rawValue), color: getColor()) {
                VStack {
                    switch store.selectedType {
                    case .work:
                        TimePicker(
                            textColor: ComponentColor.lightPink,
                            interval: $store.work.sending(\.valueUpdated)
                        )

                    case .rest:
                        TimePicker(
                            textColor: ComponentColor.lightYellow,
                            interval: $store.rest.sending(\.valueUpdated)
                        )

                    case .series:
                        NumberPicker(
                            textColor: ComponentColor.lightBlue,
                            value: $store.series.sending(\.valueUpdated)
                        )

                    case .rounds:
                        NumberPicker(
                            textColor: ComponentColor.lightGreen,
                            value: $store.rounds.sending(\.valueUpdated)
                        )

                    default:
                        TimePicker(
                            textColor: ComponentColor.braun,
                            interval: $store.reset.sending(\.valueUpdated)
                        )
                    }
                }
                .padding(.bottom)
            }
            .onCloseTab { store.send(.activitySheetVisibilityChanged(false)) }
            .presentationDetents([.fraction(0.5)])
        })
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

    private func getColor() -> ComponentColor {
        switch store.selectedType {
        case .rest:
            return .lightYellow

        case .series:
            return .lightBlue

        case .rounds:
            return .lightGreen

        case .reset:
            return .braun

        default:
            return .lightPink
        }
    }
}

#Preview {
    WorkoutEditView(store: ComposableArchitecture.Store(initialState: WorkoutEditFeature.State(
        headerText: .saveWorkout,
        name: "name",
        work: 30,
        rest: 60,
        series: 3,
        rounds: 2,
        reset: 60
    )) {
        WorkoutEditFeature()
            ._printChanges()
    })
}
