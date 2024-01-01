//
//  ContentView.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 06.11.2022.
//

import SwiftUI

struct WorkOutContentScene: View {
    @Environment(\.scenePhase) var scenePhase

    @StateObject var viewModel = WorkOutContentViewModel()

    @StateObject var workOutViewModel = WorkOutViewModel()
    @StateObject var libraryViewModel = LibraryViewModel()

    var body: some View {
        NavigationBaseView(currentTab: viewModel.currentTab) {
            WorkOutScene(isRunViewVisible: $workOutViewModel.isRunViewVisible)
                .environmentObject(workOutViewModel)
        } library: {
            LibraryScene()
                .environmentObject(libraryViewModel)
        }
        .onChange(of: scenePhase) { _, newValue in
            workOutViewModel.scenePhase = newValue
        }
    }
}

struct ContentScene_Previews: PreviewProvider {
    static var previews: some View {
        WorkOutContentScene()
    }
}
