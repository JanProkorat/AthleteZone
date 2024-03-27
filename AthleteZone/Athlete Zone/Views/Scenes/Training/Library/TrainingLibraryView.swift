//
//  TrainingLibraryView.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 01.03.2024.
//

import ComposableArchitecture
import SwiftUI

struct TrainingLibraryView: View {
    @Bindable var store: StoreOf<TrainingLibraryFeature>
    @State var trainingForDetail: TrainingDto?

    var body: some View {
        LibraryBaseView(
            searchText: $store.searchText.sending(\.searchTextChanged),
            sortOrder: $store.sortOrder.sending(\.sortOrderChanged),
            noContentText: store.library.isEmpty ? LocalizationKey.noTrainingsToDisplay : nil
        ) {
            TrainingSortByPicker()
                .onPropertySelected { store.send(.sortByChanged($0)) }
        } content: {
            List {
                ForEach(store.library, id: \.id) { training in
                    TrainingListView(training: training)
                        .onDeleteTab { store.send(.deleteTapped(training.id)) }
                        .onEditTab { store.send(.editTapped(training)) }
                        .onInfoTab { trainingForDetail = training }
                        .onSelectTab { store.send(.selectTapped(training.id)) }
                        .id(training.id)
                        .transition(.scale)
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                }
            }
            .listStyle(.plain)
        }
        .sheet(item: $trainingForDetail) { _ in
            TrainingDetailView(training: $trainingForDetail)
                .presentationDetents([.fraction(0.9)])
        }
        .sheet(item: $store.scope(state: \.destination?.addSheet, action: \.destination.addSheet)) { store in
            TrainingEditView(store: store)
        }
    }
}

#Preview {
    TrainingLibraryView(store: ComposableArchitecture.Store(initialState: TrainingLibraryFeature.State(), reducer: {
        TrainingLibraryFeature()
    }))
}
