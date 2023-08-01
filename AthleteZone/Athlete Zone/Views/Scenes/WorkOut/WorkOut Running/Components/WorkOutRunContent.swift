//
//  ExerciseRunContent.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 07.11.2022.
//

import SwiftUI

struct WorkOutRunContent: View {
    @EnvironmentObject var viewModel: WorkOutRunViewModel
    @State private var timeElapsed: TimeInterval = 0

    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            if let flow = self.viewModel.selectedFlow {
                DescriptionLabel(title: "Round \(flow.round)/\(flow.totalRounds)",
                                 color: ComponentColor.rounds)
                DescriptionLabel(title: "Exercise \(flow.serie)/\(flow.totalSeries)",
                                 color: ComponentColor.series)

                Text(LocalizedStringKey(flow.type.rawValue))
                    .font(.custom("Lato-Black", size: 20))
                    .bold()
                    .padding(.top, 10)
                    .frame(maxWidth: .infinity, alignment: .center)

                GeometryReader { geo in
                    VStack(spacing: 0) {
                        ZStack {
                            CircularProgressBar(color: flow.color, progress: flow.getProgress())
                            CounterText(text: flow.interval.toFormattedTime(), size: geo.size.height * 0.14)
                        }
                        .frame(maxWidth: .infinity)

                        HStack(alignment: .center) {
                            IconButton(
                                id: "start",
                                image: viewModel.state == .running ? Icons.actionsPause.rawValue : Icons.start.rawValue,
                                color: ComponentColor.action,
                                width: geo.size.height * 0.3,
                                height: geo.size.height * 0.3
                            )
                            .onTab {
                                viewModel.setState(viewModel.state == .running ? .paused : .running)
                            }
                            IconButton(
                                id: "forward",
                                image: Icons.actionsForward.rawValue,
                                color: ComponentColor.action,
                                width: geo.size.height * 0.26,
                                height: geo.size.height * 0.26
                            )
                            .onTab {
                                if !viewModel.isLastRunning {
                                    viewModel.selectedFlowIndex += 1
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            viewModel.setState(.running)
//            timeElapsed = TimerManager.shared.getTimeElapsed() // Update the initial timeElapsed value
        }
        .onReceive(TimerManager.shared.timePublisher) { elapsed in
            timeElapsed = elapsed // Update the timeElapsed value whenever the timer updates
        }
        .onChange(of: viewModel.state) { newValue in
            switch newValue {
            case .running:
                UIApplication.shared.isIdleTimerDisabled = true

            default:
                UIApplication.shared.isIdleTimerDisabled = false
            }
        }
    }
}

struct WorkOutRunContent_Previews: PreviewProvider {
    static var previews: some View {
        WorkOutRunContent()
            .environmentObject(WorkOutRunViewModel(
                workout: WorkOut("Prvni", 2, 2, 2, 2, 2)
            ))
    }
}
