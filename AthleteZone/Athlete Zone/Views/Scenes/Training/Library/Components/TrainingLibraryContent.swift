//
//  TrainingLibraryContent.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 03.07.2023.
//

import SwiftUI

struct TrainingLibraryContent: View {
    @EnvironmentObject var viewModel: TrainingLibraryViewModel
    @State var trainingForDetailt: Training?

    var onEditTab: ((_ value: Training) -> Void)?

    init() {
        UICollectionView.appearance().backgroundColor = UIColor(Color(ComponentColor.darkBlue.rawValue))
    }

    var body: some View {
        LibraryBaseView(searchText: $viewModel.searchText, sortOrder: $viewModel.sortOrder) {
            TrainingSortByPicker()
                .onPropertySelected { viewModel.sortBy = $0 }
        } content: {
            List(viewModel.library, id: \._id) { training in
                Button {
                    self.viewModel.setSelectedTraining(training)
                    self.viewModel.router.currentTab = .home
                } label: {
                    TrainingListView(training: training)
                        .onDeleteTab { viewModel.removeTraining(training) }
                        .onEditTab { performAction(onEditTab, value: training) }
                        .onInfoTab { trainingForDetailt = training }
                        .padding([.leading, .trailing], 2)
                }
                .padding(.bottom, 7)
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                .background(Color(ComponentColor.darkBlue.rawValue))
            }
            .listStyle(.plain)
            .id(viewModel.library)
            .overlay(alignment: .top) {
                if viewModel.library.isEmpty {
                    Text(LocalizationKey.noTrainingsToDisplay.localizedKey)
                        .font(.headline)
                        .bold()
                        .padding(.top, 100)
                }
            }
        }
        .sheet(item: $trainingForDetailt) { training in
            TrainingDetailView(training: training)
                .presentationDetents([.fraction(0.9)])
        }
    }
}

struct TrainingLibraryContent_Previews: PreviewProvider {
    static var previews: some View {
        TrainingLibraryContent()
            .environmentObject(TrainingLibraryViewModel())
    }
}

extension TrainingLibraryContent {
    func onEditTab(_ handler: @escaping (_ value: Training) -> Void) -> TrainingLibraryContent {
        var new = self
        new.onEditTab = handler
        return new
    }
}
