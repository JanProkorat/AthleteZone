//
//  HistoryContent.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 30.11.2023.
//

import SwiftUI

struct HistoryContent: View {
    @EnvironmentObject var viewModel: HistoryViewModel
    @State var itemForSheet: StopWatch?

    var onSubmitTab: ((_ name: String) -> Void)?

    var body: some View {
        LibraryBaseView(searchText: $viewModel.searchText, sortOrder: $viewModel.sortOrder) {
            StopWatchSortByPicker()
                .onPropertySelected { viewModel.sortBy = $0 }
        } content: {
            List(viewModel.library, id: \.id) { activity in
                Button {
                    itemForSheet = activity
                } label: {
                    StopWatchListItem(activity: activity)
                        .onSubmitTab { name in
                            viewModel.updateActivity(activity.id, name)
                        }
                        .onDeleteTab {
                            viewModel.deleteActivity(activity)
                        }
                }
                .listRowInsets(EdgeInsets(top: 3, leading: 0, bottom: 3, trailing: 0))
                .listRowBackground(Color(ComponentColor.darkBlue.rawValue))
            }
            .listStyle(.plain)
            .id(viewModel.library)
            .overlay(alignment: .top) {
                if viewModel.library.isEmpty {
                    Text(LocalizationKey.noActivities.localizedKey)
                        .font(.headline)
                        .bold()
                        .padding(.top, 100)
                }
            }
        }
        .sheet(item: $itemForSheet) { activity in
            ActivityDetailView(activity: activity)
                .presentationDetents([.fraction(0.7)])
        }
    }
}

#Preview {
    HistoryContent()
        .environmentObject(HistoryViewModel())
}
