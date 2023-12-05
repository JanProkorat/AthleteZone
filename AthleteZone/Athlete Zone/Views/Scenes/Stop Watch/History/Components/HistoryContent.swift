//
//  HistoryContent.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 30.11.2023.
//

import SwiftUI

struct HistoryContent: View {
    @EnvironmentObject var viewModel: HistoryViewModel

    var body: some View {
        VStack {
            SearchBar(text: $viewModel.searchText)
                .padding(5)
            HStack {
                StopWatchSortByPicker()
                    .onPropertySelected { viewModel.sortBy = $0 }
                SortOrderPicker()
                    .onOrderSelected { viewModel.sortOrder = $0 }
            }
            .padding([.leading, .trailing, .bottom], 5)

            List {
                ForEach(viewModel.library) { activity in
                    StopWatchListItem(activity: activity)
                        .onSubmitTab { name in
                            viewModel.updateActivity(activity._id.stringValue, name)
                        }
                        .listRowInsets(EdgeInsets(top: 3, leading: 0, bottom: 3, trailing: 0))
                        .listRowBackground(Color(ComponentColor.darkBlue.rawValue))
                }
                .onDelete { indexSet in
                    viewModel.deleteActivities(at: indexSet)
                }
            }
            .listStyle(.plain)
            .overlay(alignment: .top) {
                if viewModel.library.isEmpty {
                    Text(LocalizationKey.noActivities.localizedKey)
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
    HistoryContent()
        .environmentObject(HistoryViewModel())
}
