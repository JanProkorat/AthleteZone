//
//  HistoryView.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 12.03.2024.
//

import SwiftUI
import ComposableArchitecture

struct HistoryView: View {
    @Bindable var store: StoreOf<HistoryFeature>

    var body: some View {
        LibraryBaseView(
            searchText: $store.searchText.sending(\.searchTextChanged),
            sortOrder: $store.sortOrder.sending(\.sortOrderChanged),
            noContentText: store.library.isEmpty ? LocalizationKey.noWorkoutsToDisplay : nil
        ) {
            StopWatchSortByPicker()
                .onPropertySelected { store.send(.sortByChanged($0)) }
        } content: {
            List {
                ForEach(store.library, id: \.id) { activity in
                    StopWatchListItem(activity: activity)
                        .onSelectTab { store.send(.selectTapped(activity)) }
                        .onDeleteTab { store.send(.deleteTapped(activity.id)) }
                        .onEditTab { store.send(.editTapped(activity)) }
                        .id(activity.id)
                        .transition(.scale)
                        .frame(height: 150)
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                }
            }
            .listStyle(.plain)
        }
        .sheet(item: $store.itemForDetail.sending(\.selectTapped)) { _ in
            ActivityDetailView(activity: $store.itemForDetail.sending(\.selectTapped))
                .presentationDetents([.fraction(0.7)])
        }
        .sheet(item: $store.itemForEdit.sending(\.editTapped)) { activity in
            ActivityEditView(name: activity.name, splitTimes: activity.splitTimes)
                .onCloseTab { store.send(.editTapped(nil)) }
                .onSaveTab {
                    store.send(.updateActivity(activity.id, $0))
                }
        }
    }
}

#Preview {
    HistoryView(store: ComposableArchitecture.Store(initialState: HistoryFeature.State(), reducer: {
        HistoryFeature()
            ._printChanges()
    }))
}
