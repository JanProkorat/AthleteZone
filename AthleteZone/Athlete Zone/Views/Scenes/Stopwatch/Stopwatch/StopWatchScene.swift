//
//  StopWatchScene.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 30.11.2023.
//

import SwiftUI

struct StopWatchScene: View {
    @EnvironmentObject var viewModel: StopWatchViewModel

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
                    interval: $viewModel.interval,
                    state: $viewModel.state,
                    splitTimes: $viewModel.splitTimes,
                    type: $viewModel.type
                )
            },
            footer: {
                MenuBar(activeTab: viewModel.router.currentTab)
                    .onRouteTab { viewModel.router.currentTab = $0 }
            }
        )
    }
}

#Preview {
    StopWatchScene()
        .environmentObject(StopWatchViewModel())
}
