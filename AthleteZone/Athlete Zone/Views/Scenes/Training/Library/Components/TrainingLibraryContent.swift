//
//  TrainingLibraryContent.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 03.07.2023.
//

import SwiftUI

struct TrainingLibraryContent: View {
    var library: [Training]
    @Binding var searchText: String
    @Binding var sortOrder: SortOrder
    @Binding var sortBy: TrainingSortByProperty

    @State var trainingForDetailt: Training?

    var onEditTab: ((_ training: Training) -> Void)?
    var onDeleteTab: ((_ training: Training) -> Void)?
    var onSelectTab: ((_ training: Training) -> Void)?

    var body: some View {
        LibraryBaseView(searchText: $searchText, sortOrder: $sortOrder) {
            TrainingSortByPicker()
                .onPropertySelected { sortBy = $0 }
        } content: {
            List {
                ForEach(library, id: \.id) { training in
                    TrainingListView(training: training)
                        .onDeleteTab { performAction(onDeleteTab, value: training) }
                        .onEditTab { performAction(onEditTab, value: training) }
                        .onInfoTab { trainingForDetailt = training }
                        .onSelectTab { performAction(onSelectTab, value: training) }
                        .id(training.id)
                        .transition(.scale)
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                }
            }
            .listStyle(.plain)
            .overlay(alignment: .top) {
                if library.isEmpty {
                    Text(LocalizationKey.noTrainingsToDisplay.localizedKey)
                        .font(.headline)
                        .bold()
                        .padding(.top, 100)
                }
            }
        }
        .sheet(item: $trainingForDetailt) { _ in
            TrainingDetailView(training: $trainingForDetailt)
                .presentationDetents([.fraction(0.9)])
        }
    }
}

struct TrainingLibraryContent_Previews: PreviewProvider {
    static var previews: some View {
        TrainingLibraryContent(
            library: [Training(), Training()],
            searchText: Binding.constant(""),
            sortOrder: Binding.constant(.ascending),
            sortBy: Binding.constant(.name)
        )
    }
}

extension TrainingLibraryContent {
    func onEditTab(_ handler: @escaping (_ training: Training) -> Void) -> TrainingLibraryContent {
        var new = self
        new.onEditTab = handler
        return new
    }

    func onSelectTab(_ handler: @escaping (_ training: Training) -> Void) -> TrainingLibraryContent {
        var new = self
        new.onSelectTab = handler
        return new
    }

    func onDeleteTab(_ handler: @escaping (_ training: Training) -> Void) -> TrainingLibraryContent {
        var new = self
        new.onDeleteTab = handler
        return new
    }
}
