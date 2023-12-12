//
//  LibraryBaseView.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 07.12.2023.
//

import RealmSwift
import SwiftUI

struct LibraryBaseView<SortByPicker: View, Content: View>: View {
    let sortByPicker: SortByPicker
    let content: Content

    @Binding var searchText: String
    @Binding var sortOrder: SortOrder

    init(
        searchText: Binding<String>,
        sortOrder: Binding<SortOrder>,
        @ViewBuilder sortByPicker: () -> SortByPicker,
        @ViewBuilder content: () -> Content
    ) {
        self.sortByPicker = sortByPicker()
        self.content = content()
        self._searchText = searchText
        self._sortOrder = sortOrder
    }

    var body: some View {
        VStack {
            SearchBar(text: $searchText)
                .padding(5)
            HStack {
                sortByPicker

                SortOrderPicker()
                    .onOrderSelected { sortOrder = $0 }
            }
            .padding([.leading, .trailing, .bottom], 5)

            content
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
}

#Preview {
    LibraryBaseView(searchText: Binding.constant(""), sortOrder: Binding.constant(.ascending)) {
        StopWatchSortByPicker()
    } content: {
        Text("test")
    }
}
