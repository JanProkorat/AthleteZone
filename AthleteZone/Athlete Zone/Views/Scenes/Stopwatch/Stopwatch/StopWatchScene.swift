//
//  StopWatchScene.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 30.11.2023.
//

import SwiftUI

struct StopWatchScene: View {
    @EnvironmentObject var viewModel: StopWatchViewModel
    @Environment(\.footerSize) var footerSize: CGFloat

    var body: some View {
        BaseView(
            header: {
                StopWatchHeader(
                    state: $viewModel.state,
                    section: $viewModel.type
                )
            },
            content: {
                StopWatchContent(
                    stopWatchInterval: $viewModel.stopWatchInterval,
                    timerInterval: $viewModel.timerInterval,
                    state: $viewModel.state,
                    splitTimes: $viewModel.splitTimes,
                    type: $viewModel.type
                )
            },
            footer: {
                if viewModel.state == .running || viewModel.state == .paused {
                    HStack {
                        Button {
                            viewModel.state = .quit
                        } label: {
                            Text(LocalizationKey.quitTracking.localizedKey)
                                .font(.title3)
                        }
                        .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .frame(maxHeight: /*@START_MENU_TOKEN@*/ .infinity/*@END_MENU_TOKEN@*/)

                } else {
                    MenuBar(activeTab: viewModel.router.currentTab)
                        .onRouteTab { viewModel.router.currentTab = $0 }
                }
            }
        )
        .animation(.easeInOut, value: viewModel.state)
    }
}

#Preview {
    StopWatchScene()
        .environmentObject(StopWatchViewModel())
        .environment(\.footerSize, 50)
}
