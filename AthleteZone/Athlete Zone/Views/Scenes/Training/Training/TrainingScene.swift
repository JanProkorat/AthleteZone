//
//  TrainingScene.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 24.03.2023.
//

import SwiftUI

struct TrainingScene: View {
    @EnvironmentObject var viewModel: TrainingViewModel

    @State var isEditModalActive = false
    @Binding var isRunViewVisible: Bool

    var body: some View {
        BaseView {
            TrainingHeader(name: viewModel.selectedTrainingManager.selectedTraining?.name)
                .onAddTab { isEditModalActive.toggle() }
        } content: {
            TrainingContent()
                .onCreateTab { isEditModalActive.toggle() }
                .onStartTab { viewModel.setupRunViewModel() }
                .onLibraryTab {
                    withAnimation {
                        viewModel.router.currentTab = .library
                    }
                }
        } footer: {
            MenuBar(activeTab: viewModel.router.currentTab)
                .onRouteTab { viewModel.router.currentTab = $0 }
        }
        .sheet(isPresented: $isEditModalActive, content: {
            TrainingEditScene()
                .onCloseTab { isEditModalActive.toggle() }
                .environmentObject(getViewModel())
        })
        .fullScreenCover(isPresented: $isRunViewVisible, content: {
            TrainingRunScene(viewModel: viewModel.runViewModel)
        })
    }

    private func getViewModel() -> TrainingEditViewModel {
        if let training = viewModel.selectedTraining {
            return TrainingEditViewModel(training: training)
        }
        return TrainingEditViewModel()
    }
}

struct TrainingScene_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = TrainingViewModel()
        viewModel.workouts = [WorkOut(), WorkOut(), WorkOut(), WorkOut()]
        viewModel.selectedTraining = Training(name: "test", description: "", workouts: [])
        return TrainingScene(isRunViewVisible: .constant(false))
            .environmentObject(viewModel)
    }
}
