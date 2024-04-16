//
//  LibraryBaseView.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 07.12.2023.
//

import SwiftUI

struct LibraryBaseView<SortByPicker: View, Content: View>: View {
    let sortByPicker: SortByPicker
    let content: Content

    @Binding var searchText: String
    @Binding var sortOrder: SortOrder
    var noContentText: LocalizationKey?

    init(
        searchText: Binding<String>,
        sortOrder: Binding<SortOrder>,
        noContentText: LocalizationKey?,
        @ViewBuilder sortByPicker: () -> SortByPicker,
        @ViewBuilder content: () -> Content
    ) {
        self.sortByPicker = sortByPicker()
        self.content = content()
        self.noContentText = noContentText
        self._searchText = searchText
        self._sortOrder = sortOrder
    }

    var body: some View {
        VStack {
            SearchBar(text: $searchText)
                .padding([.top, .bottom], 5)
            HStack {
                sortByPicker

                SortOrderPicker()
                    .onOrderSelected { sortOrder = $0 }
            }
            .padding([.leading, .trailing, .bottom], 5)

            content
                .overlay(alignment: .top) {
                    if let text = noContentText {
                        Text(text.localizedKey)
                            .font(.headline)
                            .bold()
                            .padding(.top, 100)
                    }
                }
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
}

#Preview {
    LibraryBaseView(searchText: Binding.constant(""), sortOrder: Binding.constant(.ascending), noContentText: .noWorkoutsToDisplay) {
        StopWatchSortByPicker()
    } content: {
        Text("test")
    }
}
