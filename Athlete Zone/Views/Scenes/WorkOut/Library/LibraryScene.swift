//
//  LibraryView.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 05.11.2022.
//

import RealmSwift
import SwiftUI

struct LibraryScene: View {
    @EnvironmentObject var viewModel: LibraryViewModel

    @State var workoutToEdit: WorkOut?
    @State var showModal = false

    var body: some View {
        BaseView(
            header: {
                LibraryHeader()
                    .onAddTab { self.showModal.toggle() }
            },
            content: {
                LibraryContent()
                    .onEditTab { newValue in
                        self.workoutToEdit = newValue
                        self.showModal.toggle()
                    }
                    .id(showModal)
            },
            footer: {
                MenuBar(activeTab: viewModel.router.currentTab)
                    .onRouteTab { viewModel.router.currentTab = $0 }
            }
        )
        .fullScreenCover(isPresented: $showModal, content: {
            WorkOutEditScene()
                .onCloseTab {
                    showModal.toggle()
                    workoutToEdit = nil
                }
                .environmentObject(workoutToEdit == nil ?
                    WorkOutEditViewModel() :
                    WorkOutEditViewModel(workout: workoutToEdit!))
        })
    }
}

struct LibraryScene_Previews: PreviewProvider {
    static var previews: some View {
        LibraryScene()
            .environmentObject(LibraryViewModel())
            .environmentObject(WorkOutViewModel())
    }
}
