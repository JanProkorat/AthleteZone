//
//  LibraryContent.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 07.11.2022.
//

import SwiftUI

struct LibraryContent: View {
    var library: [WorkOut]
    @Binding var searchText: String
    @Binding var sortOrder: SortOrder
    @Binding var sortBy: WorkOutSortByProperty

    var onEditTab: ((_ workOut: WorkOut) -> Void)?
    var onDeleteTab: ((_ workOut: WorkOut) -> Void)?
    var onSelectTab: ((_ workOut: WorkOut) -> Void)?

    var body: some View {
        LibraryBaseView(searchText: $searchText, sortOrder: $sortOrder) {
            SortByPicker()
                .onPropertySelected { sortBy = $0 }
        } content: {
            List {
                ForEach(library, id: \.id) { workout in
                    WorkOutListView(workOut: workout)
                        .onSelectTab { performAction(onSelectTab, value: workout) }
                        .onDeleteTab { performAction(onDeleteTab, value: workout) }
                        .onEditTab { performAction(onEditTab, value: workout.thaw()!) }
                        .id(workout.id)
                        .transition(.scale)
                        .frame(height: 175)
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                }
            }
            .listStyle(.plain)
            .overlay(alignment: .top) {
                if library.isEmpty {
                    Text(LocalizationKey.noWorkoutsToDisplay.localizedKey)
                        .font(.headline)
                        .bold()
                        .padding(.top, 100)
                }
            }
        }
    }
}

struct LibraryContent_Previews: PreviewProvider {
    static var previews: some View {
        LibraryContent(
            library: [WorkOut(), WorkOut()],
            searchText: Binding.constant(""),
            sortOrder: Binding.constant(.ascending),
            sortBy: Binding.constant(.name)
        )
    }
}

extension LibraryContent {
    func onEditTab(_ handler: @escaping (_ value: WorkOut) -> Void) -> LibraryContent {
        var new = self
        new.onEditTab = handler
        return new
    }

    func onDeleteTab(_ handler: @escaping (_ value: WorkOut) -> Void) -> LibraryContent {
        var new = self
        new.onDeleteTab = handler
        return new
    }

    func onSelectTab(_ handler: @escaping (_ value: WorkOut) -> Void) -> LibraryContent {
        var new = self
        new.onSelectTab = handler
        return new
    }
}
