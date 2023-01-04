//
//  LibraryView.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 05.11.2022.
//

import RealmSwift
import SwiftUI

struct LibraryScene: View {
    @State var isEditing: Bool
    @State var workOutToEdit: WorkOut?
    @EnvironmentObject var router: ViewRouter
    @EnvironmentObject var viewModel: WorkOutViewModel

    init() {
        isEditing = false
    }

    var body: some View {
        BaseView(
            header: {
                LibraryHeader()
                    .onAddTab {
                        workOutToEdit = WorkOut()
                    }
            },
            content: {
                LibraryContent()
                    .onEditTab {
                        isEditing = true
                        workOutToEdit = $0
                    }
            },
            footer: {
                MenuBar(activeTab: router.currentTab)
                    .onRouteTab { router.currentTab = $0 }
            }
        )
        .fullScreenCover(item: $workOutToEdit, content: { value in
            WorkOutEditScene(value.name, value.work, value.rest, value.series, value.rounds, value.reset, $isEditing)
                .onCloseTab {
                    workOutToEdit = nil
                    isEditing = false
                }
                .onSaveTab { value in
                    switch isEditing {
                    case true:
                        isEditing = false
                        viewModel.update(workOutToEdit: workOutToEdit!, updatedWorkOut: value)

                    case false:
                        viewModel.saveWorkOut(value)
                    }
                    workOutToEdit = nil
                }
        })
    }
}

struct LibraryScene_Previews: PreviewProvider {
    static var previews: some View {
        LibraryScene()
            .environmentObject(WorkOutViewModel())
            .environmentObject(ViewRouter())
    }
}
