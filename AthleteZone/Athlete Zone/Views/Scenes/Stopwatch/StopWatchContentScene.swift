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
        NavigationBaseView(currentTab: viewModel.currentTab) {
            StopWatchScene()
                .environmentObject(stopWatchViewModel)
        } library: {
            HistoryScene()
                .environmentObject(historyViewModel)
        }
    }
}

#Preview {
    StopWatchContentScene()
}
