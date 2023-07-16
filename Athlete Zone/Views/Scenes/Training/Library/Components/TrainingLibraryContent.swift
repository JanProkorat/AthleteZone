//
//  TrainingLibraryContent.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 03.07.2023.
//

import SwiftUI

struct TrainingLibraryContent: View {
    @EnvironmentObject var viewModel: TrainingLibraryViewModel
    @EnvironmentObject var router: ViewRouter

    var onEditTab: ((_ value: Training) -> Void)?

    var body: some View {
        VStack {
            SearchBar(text: $viewModel.searchText)
                .padding(5)
            HStack {
                TrainingSortByPicker()
                    .onPropertySelected { viewModel.sortBy = $0 }
                SortOrderPicker()
                    .onOrderSelected { viewModel.sortOrder = $0 }
            }
            .padding([.leading, .trailing, .bottom], 5)

            ZStack(alignment: .top) {
                List(viewModel.library, id: \._id) { training in
                    Button {
                        self.viewModel.setSelectedTraining(training)
                        self.router.currentTab = .home
                    } label: {
                        TrainingListView(training: training)
                            .onDeleteTab { viewModel.removeTraining(training) }
                            .onEditTab { performAction(onEditTab, value: training) }
                            .padding([.leading, .trailing], 2)
                    }
                    .padding(.bottom, 110)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .background(Color(Background.background.rawValue))
                }
                .listStyle(.plain)

                if viewModel.library.isEmpty {
                    Text("No trainings to display.")
                        .font(.headline)
                        .bold()
                        .padding(.top, 100)
                }
            }
        }
    }
}

struct TrainingLibraryContent_Previews: PreviewProvider {
    static var previews: some View {
        TrainingLibraryContent()
            .environmentObject(TrainingLibraryViewModel())
            .environmentObject(ViewRouter())
    }
}

extension TrainingLibraryContent {
    func onEditTab(_ handler: @escaping (_ value: Training) -> Void) -> TrainingLibraryContent {
        var new = self
        new.onEditTab = handler
        return new
    }
}
