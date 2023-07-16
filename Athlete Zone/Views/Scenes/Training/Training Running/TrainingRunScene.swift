//
//  TrainingRunScene.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 30.03.2023.
//

import SwiftUI

struct TrainingRunScene: View {
    @EnvironmentObject var viewModel: TrainingRunViewModel
    @EnvironmentObject var router: ViewRouter

    var body: some View {
        BaseView {
            TrainingRunHeader(title: viewModel.trainingName)
        } content: {
            TrainingRunContent()
                .environmentObject(viewModel.selectedWorkFlowViewModel)
        } footer: {
            TrainingRunFooter()
                .onQuitTab {
                    viewModel.selectedWorkFlowViewModel.onQuitTab()
                    router.currentTab = .home
                }
                .environmentObject(viewModel.selectedWorkFlowViewModel)
        }
    }
}

struct TrainingRunScene_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = TrainingRunViewModel()
        viewModel.initTraining(name: "test", workouts: [
            WorkOut("Prvni", 2, 2, 2, 2, 2),
            WorkOut("Druhy", 5, 5, 5, 5, 5)
        ])
        return TrainingRunScene()
            .environmentObject(viewModel)
            .environmentObject(ViewRouter())
    }
}
