//
//  LibraryScene.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 03.07.2023.
//

import SwiftUI

struct TrainingLibraryScene: View {
    @EnvironmentObject var viewModel: TrainingLibraryViewModel

    @State var trainingToEdit: Training?
    @State var showModal = false

    var body: some View {
        BaseView(
            header: {
                TrainingLibraryHeader()
                    .onAddTab { self.showModal.toggle() }
            },
            content: {
                TrainingLibraryContent(
                    library: viewModel.library,
                    searchText: $viewModel.searchText,
                    sortOrder: $viewModel.sortOrder,
                    sortBy: $viewModel.sortBy
                )
                .onEditTab { training in
                    self.trainingToEdit = training
                    self.showModal.toggle()
                }
                .onSelectTab { training in
                    self.viewModel.setSelectedTraining(training)
                    withAnimation {
                        self.viewModel.router.currentTab = .home
                    }
                }
                .onDeleteTab { training in
                    viewModel.removeTraining(training)
                }
                .id(showModal)
            }
        )
        .sheet(isPresented: $showModal, content: {
            TrainingEditScene()
                .onCloseTab {
                    showModal.toggle()
                }
                .environmentObject(trainingToEdit == nil ?
                    TrainingEditViewModel() :
                    TrainingEditViewModel(training: trainingToEdit!))
                .onDisappear {
                    trainingToEdit = nil
                }
        })
    }
}

struct TrainingLibraryScene_Previews: PreviewProvider {
    static var previews: some View {
        TrainingLibraryScene()
            .environmentObject(TrainingLibraryViewModel())
    }
}
