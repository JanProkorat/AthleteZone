//
//  ExerciseRunContent.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 07.11.2022.
//

import SwiftUI

struct WorkOutRunContent: View {
    @EnvironmentObject var viewModel: WorkFlowViewModel

    @State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    @State var isRunning = true

    var onQuitTab: (() -> Void)?
    var onisRunningChange: (() -> Void)?

    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            if let flow = self.viewModel.selectedFlow {
                DescriptionLabel(title: "Round \(flow.round)/\(self.viewModel.roundsCount)",
                                 color: ComponentColor.rounds)
                DescriptionLabel(title: "Exercise \(flow.serie)/\(self.viewModel.seriesCount)",
                                 color: ComponentColor.series)

                Text("\(flow.type.rawValue)")
                    .font(.custom("Lato-Black", size: 20))
                    .bold()
                    .padding(.top, 10)
                    .frame(maxWidth: .infinity, alignment: .center)

                GeometryReader { geo in
                    VStack(spacing: 0) {
                        ZStack {
                            CircularProgressBar(
                                color: flow.type == .work ? ComponentColor.pink :
                                    flow.type == .rest ? ComponentColor.yellow : ComponentColor.braun,
                                progress: flow.getProgress()
                            )
                            CounterText(
                                text: flow.interval.toFormattedValue(type: .time),
                                size: geo.size.height * 0.14
                            )
                        }
                        .frame(maxWidth: .infinity)

                        HStack(alignment: .center) {
                            IconButton(
                                id: "start",
                                image: isRunning ? Icons.ActionsPause : Icons.Start,
                                color: ComponentColor.action,
                                width: geo.size.height * 0.3,
                                height: geo.size.height * 0.3
                            )
                            .onTab {
                                isRunning.toggle()
                                performAction(self.onisRunningChange)
                            }
                            IconButton(
                                id: "forward",
                                image: Icons.ActionsForward,
                                color: ComponentColor.action,
                                width: geo.size.height * 0.26,
                                height: geo.size.height * 0.26
                            )
                            .onTab {
                                self.viewModel.selectedFlowIndex += 1
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onReceive(timer) { _ in
            if self.viewModel.selectedFlow != nil {
                if self.viewModel.selectedFlow!.interval > 0 {
                    self.viewModel.selectedFlow!.setInterval(self.viewModel.selectedFlow!.interval - 1)
                } else {
                    self.viewModel.selectedFlowIndex += 1
                }
            }
        }
        .onChange(of: self.viewModel.selectedFlowIndex) { _ in
            if self.viewModel.selectedFlowIndex < self.viewModel.flow.count {
                self.viewModel.selectedFlow = self.viewModel.flow[self.viewModel.selectedFlowIndex]
            } else {
                self.performAction(onQuitTab)
            }
        }
        .onChange(of: isRunning) { _ in
            if !isRunning {
                self.timer.upstream.connect().cancel()
            } else {
                self.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
            }
        }
    }
}

struct WorkOutRunContent_Previews: PreviewProvider {
    static var previews: some View {
        WorkOutRunContent(isRunning: true)
            .environmentObject(WorkFlowViewModel())
            .environmentObject(ViewRouter())
            .environmentObject(WorkOutViewModel(selectedWorkOut: WorkOut()))
    }
}

extension WorkOutRunContent {
    func onQuitTab(_ handler: @escaping () -> Void) -> WorkOutRunContent {
        var new = self
        new.onQuitTab = handler
        return new
    }

    func onisRunningChange(_ handler: @escaping () -> Void) -> WorkOutRunContent {
        var new = self
        new.onisRunningChange = handler
        return new
    }
}
