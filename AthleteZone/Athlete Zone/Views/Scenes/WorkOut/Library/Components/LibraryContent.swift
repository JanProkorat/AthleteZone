//
//  LibraryContent.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 07.11.2022.
//

import CustomAlert
import SwiftUI

struct LibraryContent: View {
    @EnvironmentObject var viewModel: LibraryViewModel
    @State var alertVisible = false
    @State var workoutToDelete: WorkOut?

    var onEditTab: ((_ workOut: WorkOut) -> Void)?

    init() {
        UICollectionView.appearance().backgroundColor = UIColor(Color(ComponentColor.darkBlue.rawValue))
    }

    var body: some View {
        LibraryBaseView(searchText: $viewModel.searchText, sortOrder: $viewModel.sortOrder) {
            SortByPicker()
                .onPropertySelected { viewModel.sortBy = $0 }
        } content: {
            List(viewModel.library, id: \._id) { workout in
                Button {
                    self.viewModel.setSelectedWorkOut(workout)
                    self.viewModel.router.currentTab = .home
                } label: {
                    WorkOutListView(workOut: workout)
                        .onDeleteTab {
                            if viewModel.isWorkoutAssignedToTraining(id: workout.id) {
                                workoutToDelete = workout
                                alertVisible.toggle()
                            } else {
                                viewModel.removeWorkout(workout)
                            }
                        }
                        .onEditTab { performAction(onEditTab, value: workout.thaw()!) }
                        .padding([.leading, .trailing], 2)
                }
                .padding(.bottom, 165)
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                .background(Color(ComponentColor.darkBlue.rawValue))
            }
            .listStyle(.plain)
            .id(viewModel.library)
            .overlay(alignment: .top) {
                if viewModel.library.isEmpty {
                    Text(LocalizationKey.noWorkoutsToDisplay.localizedKey)
                        .font(.headline)
                        .bold()
                        .padding(.top, 100)
                }
            }
            .customAlert("", isPresented: $alertVisible) {
                Text("Workout is assigned to a training, are you sure you want to delete it?")
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
}

struct LibraryContent_Previews: PreviewProvider {
    static var previews: some View {
        LibraryContent()
            .environmentObject(WorkOutViewModel())
            .environmentObject(LibraryViewModel())
    }
}

extension LibraryContent {
    func onEditTab(_ handler: @escaping (_ value: WorkOut) -> Void) -> LibraryContent {
        var new = self
        new.onEditTab = handler
        return new
    }
}
