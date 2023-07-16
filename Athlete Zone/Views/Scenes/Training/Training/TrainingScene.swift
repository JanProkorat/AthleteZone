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

    @State var isModalActive = false

    var body: some View {
        BaseView {
            TrainingHeader(name: viewModel.selectedTrainingManager.selectedTraining?.name)
                .onSaveTab { isModalActive.toggle() }
        } content: {
            TrainingContent()
                .onStartTab { router.currentTab = .run }
                .onLibraryTab { router.currentTab = .library }
                .onCreateTab { isModalActive.toggle() }
        } footer: {
            MenuBar(activeTab: router.currentTab)
                .onRouteTab { router.currentTab = $0 }
        }
        .fullScreenCover(isPresented: $isModalActive, content: {
            TrainingEditScene()
                .onCloseTab { isModalActive = false }
                .environmentObject(getViewModel())
        })
    }

    private func getViewModel() -> TrainingEditViewModel {
        if let training = viewModel.selectedTrainingManager.selectedTraining {
            return TrainingEditViewModel(
                name: training.name,
                description: training.description,
                workouts: training.workouts)
        }
        return TrainingEditViewModel()
    }
}

struct TrainingScene_Previews: PreviewProvider {
    static var previews: some View {
        TrainingScene()
            .environmentObject(ViewRouter())
            .environmentObject(TrainingViewModel())
    }
}
