//
//  LibraryView.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 05.11.2022.
//

import CustomAlert
import RealmSwift
import SwiftUI

struct LibraryScene: View {
    @EnvironmentObject var viewModel: LibraryViewModel

    @State var workoutToEdit: WorkOut?
    @State var showModal = false
    @State var alertVisible = false
    @State var workoutToDelete: WorkOut?

    var body: some View {
        BaseView(
            header: {
                LibraryHeader()
                    .onAddTab { self.showModal.toggle() }
            },
            content: {
                LibraryContent(
                    library: viewModel.library,
                    searchText: $viewModel.searchText,
                    sortOrder: $viewModel.sortOrder,
                    sortBy: $viewModel.sortBy
                )
                .onSelectTab { workout in
                    self.viewModel.setSelectedWorkOut(workout)
                    withAnimation {
                        self.viewModel.router.currentTab = .home
                    }
                }
                .onEditTab { workout in
                    self.workoutToEdit = workout
                    self.showModal.toggle()
                }
                .onDeleteTab { workout in
                    if viewModel.isWorkoutAssignedToTraining(id: workout.id) {
                        workoutToDelete = workout
                        alertVisible.toggle()
                    } else {
                        viewModel.removeWorkout(workout)
                    }
                }
                .id(showModal)
            }
        )
        .sheet(isPresented: $showModal, content: {
            WorkOutEditScene()
                .onCloseTab {
                    showModal.toggle()
                }
                .environmentObject(workoutToEdit == nil ?
                    WorkOutEditViewModel() :
                    WorkOutEditViewModel(workout: workoutToEdit!))
                .onDisappear {
                    workoutToEdit = nil
                }
        })
        .customAlert("", isPresented: $alertVisible) {
            Text(LocalizationKey.removeConfirm.localizedKey)
                .font(.title2)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding([.leading, .trailing, .top])
        } actions: {
            MultiButton {
                Button {
                    viewModel.removeWorkout(workoutToDelete!)
                    workoutToDelete = nil
                    self.alertVisible = false
                } label: {
                    Text(LocalizationKey.yes.localizedKey)
                        .foregroundStyle(.red)
                }
                .transition(.move(edge: .trailing))
                Button {
                    self.alertVisible = false
                } label: {
                    Text(LocalizationKey.no.localizedKey)
                }
            }
        }
        .addAlertConfiguration()
    }
}

struct LibraryScene_Previews: PreviewProvider {
    static var previews: some View {
        LibraryScene()
            .environmentObject(LibraryViewModel())
            .environmentObject(WorkOutViewModel())
    }
}
