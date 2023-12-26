//
//  StopWatchContent.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 30.11.2023.
//

import SwiftUI

struct StopWatchContent: View {
    @Binding var stopWatchInterval: TimeInterval
    @Binding var timerInterval: TimeInterval
    @Binding var state: WorkFlowState
    @Binding var splitTimes: [TimeInterval]
    @Binding var type: TimerType

    var body: some View {
        VStack {
            switch type {
            case .stopWatch:
                StopWatchView(interval: $stopWatchInterval, state: $state, splitTimes: $splitTimes)

            case .timer:
                TimerView(interval: $timerInterval, state: $state)
            }
        }
        .onChange(of: state) { _, newValue in
            switch newValue {
            case .running:
                UIApplication.shared.isIdleTimerDisabled = true

            default:
                UIApplication.shared.isIdleTimerDisabled = false
            }
        }
    }
}

#Preview {
    StopWatchContent(
        stopWatchInterval: Binding.constant(0),
        timerInterval: Binding.constant(0),
        state: Binding.constant(.ready),
        splitTimes: Binding.constant([1, 15, 34]),
        type: Binding.constant(.stopWatch)
    )
}
