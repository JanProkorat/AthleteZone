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
                .onStartTab { viewModel.setupRunViewModel() }
                .onLibraryTab { viewModel.router.currentTab = .library }
                .onCreateTab { isEditModalActive.toggle() }
        } footer: {
            MenuBar(activeTab: viewModel.router.currentTab)
                .onRouteTab { viewModel.router.currentTab = $0 }
        }
        .fullScreenCover(isPresented: $isEditModalActive, content: {
            TrainingEditScene()
                .onCloseTab { isEditModalActive.toggle() }
                .environmentObject(TrainingEditViewModel())
        })
        .fullScreenCover(isPresented: $isRunViewVisible, content: {
            TrainingRunScene(viewModel: viewModel.runViewModel)
        })
    }
}

struct TrainingScene_Previews: PreviewProvider {
    static var previews: some View {
        TrainingScene(isRunViewVisible: .constant(false))
            .environmentObject(TrainingViewModel())
    }
}
