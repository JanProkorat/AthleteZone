//
//  LibraryView.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 05.11.2022.
//

import RealmSwift
import SwiftUI

struct LibraryScene: View {
    @EnvironmentObject var router: ViewRouter
    @EnvironmentObject var viewModel: LibraryViewModel
    @State private var isEditing = false

    var body: some View {
        BaseView(
            header: {
                LibraryHeader()
                    .onAddTab { viewModel.workoutToEdit = WorkOut() }
            },
            content: {
                LibraryContent()
                    .onEditTab {
                        self.isEditing = true
                        viewModel.workoutToEdit = $0
                    }
            },
            footer: {
                MenuBar(activeTab: router.currentTab)
                    .onRouteTab { router.currentTab = $0 }
            }
        )
        .fullScreenCover(item: $viewModel.workoutToEdit, content: { value in
            WorkOutEditScene(name: value.name, work: value.work, rest: value.rest, series: value.series,
                             rounds: value.rounds, reset: value.reset, _id: isEditing ? value._id.stringValue : nil)
                .onCloseTab { editedId in
                    if let id = editedId {
                        if id == viewModel.selectedWorkoutManager.selectedWorkout?._id.stringValue {
                            viewModel.setSelectedWorkOut(id)
                        }
                    }
                    viewModel.workoutToEdit = nil
                    isEditing = false
                }
        })
    }
}

struct LibraryScene_Previews: PreviewProvider {
    static var previews: some View {
        LibraryScene()
            .environmentObject(WorkOutViewModel())
            .environmentObject(LibraryViewModel())
            .environmentObject(ViewRouter())
    }
}
