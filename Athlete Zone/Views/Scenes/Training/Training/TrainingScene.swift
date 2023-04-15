//
//  TrainingScene.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 24.03.2023.
//

import SwiftUI

struct TrainingScene: View {
    @EnvironmentObject var router: ViewRouter
    @EnvironmentObject var viewModel: TrainingViewModel

    var body: some View {
        BaseView {
            TrainingHeader(name: viewModel.training.name)
        } content: {
            TrainingContent(training: viewModel.training)
                .onStartTab {}
        } footer: {
            MenuBar(activeTab: router.currentTab)
                .onRouteTab { router.currentTab = $0 }
        }
    }
}

struct TrainingScene_Previews: PreviewProvider {
    static var previews: some View {
        TrainingScene()
            .environmentObject(ViewRouter())
            .environmentObject(TrainingViewModel())
    }
}
