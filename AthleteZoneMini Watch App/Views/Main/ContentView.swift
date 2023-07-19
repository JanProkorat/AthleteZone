//
//  ContentView.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 08.01.2023.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: ViewModel
    @StateObject var launchScreenStateManager = LaunchScreenStateManager()
    @StateObject var appStorageManager = AppStorageManager.shared
//    @StateObject var workFlowViewModel = WorkFlowViewModel()

    var body: some View {
        Group {
            if launchScreenStateManager.state != .finished {
                LaunchScreenView()
                    .environmentObject(launchScreenStateManager)
            } else {
                TabView {
                    LibraryView()
                    FiltersView()
                }
            }
        }
        .onChange(of: viewModel.library, perform: { _ in
            if launchScreenStateManager.state != .finished {
                self.launchScreenStateManager.dismiss()
            }
        })
//        .fullScreenCover(item: $viewModel.selectedWorkOut, content: { _ in
//            WorkOutView(workFlowViewModel: workFlowViewModel)
//                .navigationBarHidden(true)
//                .environment(\.locale, .init(identifier: "\(appStorageManager.language)"))
//
//        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ViewModel())
    }
}
