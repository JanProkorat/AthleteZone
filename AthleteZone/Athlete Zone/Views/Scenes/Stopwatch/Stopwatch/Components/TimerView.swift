//
//  TimerView.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 03.12.2023.
//

import SwiftUI

struct TimerView: View {
    @Binding var interval: TimeInterval
    @Binding var state: WorkFlowState

    var body: some View {
        GeometryReader(content: { geo in
            VStack {
                TimePicker(
                    textColor: state == .ready ? .braun :
                        state == .running ? .lightPink : .braun,
                    interval: $interval)
                    .padding(.top)

                Button {
                    state = state == .running ? .paused : .running
                } label: {
                    Image(state == .running ? Icons.actionsPause.rawValue : Icons.start.rawValue)
                        .resizable()
                        .scaledToFill()
                        .foregroundColor(interval == 0 ? .grey : Color(ComponentColor.action.rawValue))
                        .frame(maxWidth: geo.size.height * 0.3, maxHeight: geo.size.height * 0.3)
                }
                .disabled(interval == 0)
                .animation(.default, value: interval)
            }
            .frame(maxHeight: .infinity)
            .padding(.bottom, 9)
        })
    }
}

#Preview {
    TimerView(interval: Binding.constant(0), state: Binding.constant(.ready))
}
