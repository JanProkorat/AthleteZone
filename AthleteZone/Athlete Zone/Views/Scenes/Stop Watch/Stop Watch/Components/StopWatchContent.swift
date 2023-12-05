//
//  StopWatchContent.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 30.11.2023.
//

import SwiftUI

struct StopWatchContent: View {
    @Binding var interval: TimeInterval
    @Binding var state: WorkFlowState
    @Binding var splitTimes: [TimeInterval]
    @Binding var type: TimerType

    var body: some View {
        switch type {
        case .stopWatch:
            StopWatchView(interval: $interval, state: $state, splitTimes: $splitTimes)

        case .timer:
            TimerView(interval: $interval, state: $state)
        }
    }
}

#Preview {
    StopWatchContent(
        interval: Binding.constant(0),
        state: Binding.constant(.ready),
        splitTimes: Binding.constant([1, 15, 34]),
        type: Binding.constant(.stopWatch)
    )
}
