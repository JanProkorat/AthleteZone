//
//  TimerContentScene.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 30.11.2023.
//

import SwiftUI

struct StopWatchContentScene: View {
    @StateObject var viewModel = StopWatchContentViewModel()

    @StateObject var stopWatchViewModel = StopWatchViewModel()
    @StateObject var historyViewModel = HistoryViewModel()
    @StateObject var settingsViewModel = SettingsViewModel()

    var body: some View {
        GeometryReader { _ in
            VStack {
                switch viewModel.currentTab {
                case .home:
                    StopWatchScene()
                        .environmentObject(stopWatchViewModel)

                case .library:
                    HistoryScene()
                        .environmentObject(historyViewModel)

                case .setting:
                    SettingsScene()
                        .environmentObject(settingsViewModel)

                default:
                    Text("Scene for this route not implemented")
                }
            }
            .animation(.easeInOut, value: viewModel.currentTab)
        }
    }
}

#Preview {
    StopWatchContentScene()
}
