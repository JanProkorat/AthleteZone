//
//  WorkoutLibraryView.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 22.02.2024.
//

import ComposableArchitecture
import SwiftUI

struct WorkoutLibraryView: View {
    @Bindable var store: StoreOf<WorkoutLibraryFeature>

    var body: some View {
        LibraryBaseView(
            searchText: $store.searchText.sending(\.searchTextChanged),
            sortOrder: $store.sortOrder.sending(\.sortOrderChanged),
            noContentText: store.library.isEmpty ? LocalizationKey.noWorkoutsToDisplay : nil
        ) {
            SortByPicker()
                .onPropertySelected { store.send(.sortByChanged($0)) }
        } content: {
            List {
                ForEach(store.library, id: \.id) { workout in
                    WorkOutListView(workOut: workout)
                        .onSelectTab { store.send(.selectTapped(workout.id)) }
                        .onDeleteTab { store.send(.deleteTapped(workout.id)) }
                        .onEditTab { store.send(.editTapped(workout)) }
                        .id(workout.id)
                        .transition(.scale)
                        .frame(height: 175)
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                }
            }
            .listStyle(.plain)
        }
        .sheet(item: $store.scope(state: \.destination?.addSheet, action: \.destination.addSheet)) { store in
            WorkoutEditView(store: store)
        }
//        .overlay {
//            if store.workoutToDeleteId != nil {
//                AthleteZoneAlert(
//                    title: "Confirm removal",
//                    description: "Workout is assigned to a training, are you sure you want to delete it?",
//                    cancelAction: {
//                        store.send(.confirmDelete(false))
//                    },
//                    cancelActionTitle: "Cancel",
//                    primaryAction: {
//                        store.send(.confirmDelete(true))
//                    },
//                    primaryActionTitle: "Confirm"
//                )
//            }
//        }
    }
}

#Preview {
    WorkoutLibraryView(store: ComposableArchitecture.Store(initialState: WorkoutLibraryFeature.State()) {
        WorkoutLibraryFeature()
            ._printChanges()
    })
}
