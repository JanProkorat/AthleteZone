//
//  WorkOutActions.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 11.02.2023.
//

import SwiftUI

struct WorkOutActions: View {
    @EnvironmentObject var workFlowViewModel: WatchWorkOutRunViewModel

    var onTab: (() -> Void)?

    var body: some View {
        BaseView(title: "Actions") {
            VStack(alignment: .center) {
                HStack(alignment: .center, spacing: 20) {
                    ActionButton(icon: Icons.actionsForward, color: .lightBlue)
                        .onTab {
                            workFlowViewModel.selectedFlowIndex -= 1
                            performAction(onTab)
                        }
                        .scaleEffect(x: -1, y: 1, anchor: .center)
                        .disabled(workFlowViewModel.selectedFlowIndex == 0)

                    ActionButton(icon: Icons.actionsForward, color: .lightGreen)
                        .onTab {
                            workFlowViewModel.selectedFlowIndex += 1
                            performAction(onTab)
                        }
                        .disabled(workFlowViewModel.isLastRunning)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                HStack(alignment: .center, spacing: 20) {
                    ActionButton(icon: workFlowViewModel.state == .running ?
                        Icons.actionsPause :
                        Icons.start, color: .lightYellow)
                        .onTab {
                            workFlowViewModel.setState(workFlowViewModel.state == .running ? .paused : .running)
                            performAction(onTab)
                        }
                        .scaleEffect(x: 1.22, y: 1.22, anchor: .center)

                    ActionButton(icon: Icons.stop, color: .braun)
                        .onTab {
                            workFlowViewModel.setState(.quit)
                        }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding([.top, .bottom])
        }
    }
}

struct WorkOutActions_Previews: PreviewProvider {
    static var previews: some View {
        WorkOutActions()
            .environmentObject(WatchWorkOutRunViewModel())
    }
}

extension WorkOutActions {
    func onTab(_ handler: @escaping () -> Void) -> WorkOutActions {
        var new = self
        new.onTab = handler
        return new
    }
}
