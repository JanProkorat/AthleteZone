//
//  FiltersView.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 24.08.2023.
//

import SwiftUI

struct TrainingFiltersView: View {
    @EnvironmentObject var viewModel: TrainingLibraryViewModel

    var body: some View {
        BaseView(title: "Filters") {
            GeometryReader { geo in
                VStack {
                    Text(LocalizedStringKey("Sort order"))
                        .foregroundColor(Color(ComponentColor.green.rawValue))
                    Picker(selection: $viewModel.sortOrder) {
                        ForEach(SortOrder.allCases) { property in
                            Text(LocalizedStringKey(property.rawValue)).tag(property)
                        }
                    } label: {}

                    Text(LocalizedStringKey("Sort by"))
                        .foregroundColor(Color(ComponentColor.green.rawValue))
                    Picker(selection: $viewModel.sortByProperty) {
                        ForEach(TrainingSortByProperty.allCases) { property in
                            Text(LocalizedStringKey(property.rawValue)).tag(property)
                        }
                    } label: {}
                }
                .frame(maxHeight: geo.size.height * 0.9)
            }
        }
    }
}

struct TrainingFiltersView_Previews: PreviewProvider {
    static var previews: some View {
        TrainingFiltersView()
            .environmentObject(TrainingLibraryViewModel())
    }
}
