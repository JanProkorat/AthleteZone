//
//  TimerView.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 21.05.2024.
//

import ComposableArchitecture
import SwiftUI

struct TimerView: View {
    @Bindable var store: StoreOf<TimerFeature>

    private let hours = Array(0...23)
    private let minutes = Array(0...59)
    private let seconds = Array(0...59)

    var body: some View {
        VStack {
            HStack {
                picker(selectedValue: $store.selectedHours.sending(\.selectedHoursChanged), range: hours)
                    .frame(maxHeight: 110)

                Text(":")
                    .foregroundColor(Color(ComponentColor.lightPink.rawValue))
                    .font(.title)

                picker(selectedValue: $store.selectedMins.sending(\.selectedMinutesChanged), range: minutes)
                    .frame(maxHeight: 110)

                Text(":")
                    .foregroundColor(Color(ComponentColor.lightPink.rawValue))
                    .font(.title)

                picker(selectedValue: $store.selectedSecs.sending(\.selectedSecondsChanged), range: seconds)
                    .frame(maxHeight: 110)
            }
            .padding(.top, -10)

            Spacer()

            NavigationLink(state: ContentFeature.Path.State.timerRun(TimerRunFeature.State(startTime: store.interval))) {
                Image(Icon.start.rawValue)
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Color(store.runDisabled ?
                            ComponentColor.grey.rawValue : ComponentColor.buttonGreen.rawValue))
                    .frame(width: 60, height: 60)
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.bottom)
            .disabled(store.runDisabled)
        }
        .padding([.leading, .trailing])
        .edgesIgnoringSafeArea(.bottom)
    }

    @ViewBuilder
    private func picker(selectedValue: Binding<Int>, range: [Int]) -> some View {
        Picker(selection: selectedValue, label: Text("")) {
            ForEach((0 ..< range.count).reversed(), id: \.self) {
                Text("\(range[$0])")
                    .foregroundColor(Color(ComponentColor.braun.rawValue))
                    .font(.title3)
            }
        }
    }
}

#Preview {
    TimerView(store: ComposableArchitecture.Store(initialState: TimerFeature.State()) {
        TimerFeature()
            ._printChanges()
    })
}
