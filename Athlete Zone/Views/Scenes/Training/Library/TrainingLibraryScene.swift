//
//  LibraryScene.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 03.07.2023.
//

import SwiftUI

struct TrainingLibraryScene: View {
    @EnvironmentObject var router: ViewRouter
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
                TrainingLibraryContent()
                    .onEditTab { newValue in
                        self.trainingToEdit = newValue
                        self.showModal.toggle()
                    }
                    .id(showModal)
            },
            footer: {
                MenuBar(activeTab: router.currentTab)
                    .onRouteTab { router.currentTab = $0 }
            }
        )
        .fullScreenCover(isPresented: $showModal, content: {
            TrainingEditScene()
                .onCloseTab {
                    showModal.toggle()
                    trainingToEdit = nil
                }
                .environmentObject(trainingToEdit == nil ?
                    TrainingEditViewModel() :
                    TrainingEditViewModel(training: trainingToEdit!))
        })
    }
}

struct TrainingLibraryScene_Previews: PreviewProvider {
    static var previews: some View {
        TrainingLibraryScene()
            .environmentObject(TrainingLibraryViewModel())
            .environmentObject(ViewRouter())
    }
}
