//
//  HistoryContent.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 30.11.2023.
//

import CustomAlert
import SwiftUI

struct HistoryContent: View {
    var library: [StopWatch]
    @Binding var searchText: String
    @Binding var sortOrder: SortOrder
    @Binding var sortBy: StopWatchSortByProperty

    @State var itemForDetail: StopWatch?
    @State var itemForEdit: StopWatch?

    var onEditSaveTab: ((_ activityInfo: (id: String, name: String)) -> Void)?
    var onDeleteTab: ((_ value: StopWatch) -> Void)?

    var body: some View {
        LibraryBaseView(searchText: $searchText, sortOrder: $sortOrder) {
            StopWatchSortByPicker()
                .onPropertySelected { sortBy = $0 }
        } content: {
            List {
                ForEach(library, id: \.id) { activity in
                    StopWatchListItem(activity: activity)
                        .onSelectTab { itemForDetail = activity }
                        .onDeleteTab { performAction(onDeleteTab, value: activity) }
                        .onEditTab { itemForEdit = activity }
                        .id(activity.id)
                        .transition(.scale)
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                }
            }
            .listStyle(.plain)
            .overlay(alignment: .top) {
                if library.isEmpty {
                    Text(LocalizationKey.noActivities.localizedKey)
                        .font(.headline)
                        .bold()
                        .padding(.top, 100)
                }
            }
        }
        .sheet(item: $itemForDetail) { _ in
            ActivityDetailView(activity: $itemForDetail)
                .presentationDetents([.fraction(0.7)])
        }
        .sheet(item: $itemForEdit) { activity in
            ActivityEditView(name: activity.name, splitTimes: activity.splitTimes)
                .onCloseTab { itemForEdit = nil }
                .onSaveTab {
                    performAction(onEditSaveTab, value: (activity.id, $0))
                    itemForEdit = nil
                }
        }
    }
}

#Preview {
    HistoryContent(
        library: [StopWatch(), StopWatch()],
        searchText: Binding.constant(""),
        sortOrder: Binding.constant(.ascending),
        sortBy: Binding.constant(.name)
    )
    .environmentObject(HistoryViewModel())
}

extension HistoryContent {
    func onEditSaveTab(_ handler: @escaping (_ activityInfo: (id: String, name: String)) -> Void) -> HistoryContent {
        var new = self
        new.onEditSaveTab = handler
        return new
    }

    func onDeleteTab(_ handler: @escaping (_ value: StopWatch) -> Void) -> HistoryContent {
        var new = self
        new.onDeleteTab = handler
        return new
    }
}
