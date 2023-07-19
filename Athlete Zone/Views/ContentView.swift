//
//  ContentView.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 14.07.2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ContentViewModel()
    @EnvironmentObject var launchScreenStateManager: LaunchScreenStateManager

    @Environment(\.scenePhase) var scenePhase

    var body: some View {
        ZStack(content: {
            switch viewModel.currentSection {
            case .workout:
                WorkOutContentScene()

            case .training:
                TrainingContentScene()
            }
        })
        .environment(\.locale, .init(identifier: "\(viewModel.currentLanguage)"))
        .environment(\.colorScheme, .dark)
        .onAppear {
            self.launchScreenStateManager.dismiss()
        }
        .background(Color(Background.background.rawValue))
        .animation(.default, value: viewModel.currentSection)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: ContentViewModel())
            .environmentObject(LaunchScreenStateManager())
    }
}
