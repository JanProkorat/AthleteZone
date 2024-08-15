//
//  IntervalSheetView.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 23.02.2024.
//

import ComposableArchitecture
import SwiftUI

struct ActivitySheetView: View {
    @Bindable var store: StoreOf<ActivitySheetFeature>

    var body: some View {
        DetailBaseView(title: LocalizedStringKey(store.type.rawValue), color: getColor()) {
            VStack {
                switch store.type {
                case .work:
                    TimePicker(
                        textColor: ComponentColor.lightPink,
                        interval: $store.value.sending(\.valueUpdated))

                case .rest:
                    TimePicker(
                        textColor: ComponentColor.lightYellow,
                        interval: $store.value.sending(\.valueUpdated))

                case .series:
                    NumberPicker(
                        textColor: ComponentColor.lightBlue,
                        value: $store.value.sending(\.valueUpdated))

                case .rounds:
                    NumberPicker(textColor: ComponentColor.lightGreen, value: $store.value.sending(\.valueUpdated))

                case .reset:
                    TimePicker(
                        textColor: ComponentColor.braun,
                        interval: $store.value.sending(\.valueUpdated))
                }
            }
            .padding(.bottom)
            .padding(.top, 25)
        }
        .onCloseTab {
            store.send(.closeTapped)
        }
    }

    private func getColor() -> ComponentColor {
        switch store.type {
        case .work:
            return .lightPink

        case .rest:
            return .lightYellow

        case .series:
            return .lightBlue

        case .rounds:
            return .lightGreen

        case .reset:
            return .braun
        }
    }
}

#Preview {
    ActivitySheetView(store: ComposableArchitecture.Store(initialState: ActivitySheetFeature.State(type: .work, value: 30)) {
        ActivitySheetFeature()
            ._printChanges()
    })
}
