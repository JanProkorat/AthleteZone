//
//  ExerciseRunContent.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 07.11.2022.
//

import SwiftUI

struct WorkOutRunContent: View {
    @EnvironmentObject var viewModel: WorkFlowViewModel

    var onQuitTab: (() -> Void)?

    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            if let flow = self.viewModel.selectedFlow {
                DescriptionLabel(title: "Round \(flow.round)/\(self.viewModel.roundsCount)",
                                 color: ComponentColor.rounds)
                DescriptionLabel(title: "Exercise \(flow.serie)/\(self.viewModel.seriesCount)",
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
                                if viewModel.state == .finished {
                                    viewModel.selectedFlowIndex = 0
                                }
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
                                    self.viewModel.selectedFlowIndex += 1
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
        }
    }
}

struct WorkOutRunContent_Previews: PreviewProvider {
    static var previews: some View {
        WorkOutRunContent()
            .environmentObject(WorkFlowViewModel())
            .environmentObject(ViewRouter())
            .environmentObject(WorkOutViewModel())
    }
}

extension WorkOutRunContent {
    func onQuitTab(_ handler: @escaping () -> Void) -> WorkOutRunContent {
        var new = self
        new.onQuitTab = handler
        return new
    }
}
