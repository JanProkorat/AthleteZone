//
//  LibraryContent.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 07.11.2022.
//

import SwiftUI

struct LibraryContent: View {
    @EnvironmentObject var viewModel: LibraryViewModel
    @EnvironmentObject var router: ViewRouter

    var onEditTab: ((_ workOut: WorkOut) -> Void)?

    init() {
        UICollectionView.appearance().backgroundColor = UIColor(Color(Background.background.rawValue))
    }

    var body: some View {
        VStack {
            SearchBar(text: $viewModel.searchText)
                .padding(5)
            HStack {
                SortByPicker()
                    .onPropertySelected { viewModel.sortBy = $0 }
                SortOrderPicker()
                    .onOrderSelected { viewModel.sortOrder = $0 }
            }
            .padding([.leading, .trailing, .bottom], 5)

            ZStack(alignment: .top) {
                List(viewModel.library, id: \._id) { workout in
                    Button {
                        self.viewModel.setSelectedWorkOut(workout)
                        self.router.currentTab = .home
                    } label: {
                        WorkOutListView(workOut: workout)
                            .onDeleteTab {
                                viewModel.removeWorkout(workout)
                            }
                            .onEditTab {
                                self.performAction(onEditTab, value: workout.thaw()!)
                            }
                            .padding([.leading, .trailing], 2)
                    }
                    .padding(.bottom, 150)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .background(Color(Background.background.rawValue))
                }
                .listStyle(.plain)

                if viewModel.library.isEmpty {
                    Text("No workouts to display.")
                        .font(.headline)
                        .bold()
                        .padding(.top, 100)
                }
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
}

struct LibraryContent_Previews: PreviewProvider {
    static var previews: some View {
        LibraryContent()
            .environmentObject(LibraryViewModel())
            .environmentObject(WorkOutViewModel())
            .environmentObject(ViewRouter())
    }
}

extension LibraryContent {
    func onEditTab(_ handler: @escaping (_ value: WorkOut) -> Void) -> LibraryContent {
        var new = self
        new.onEditTab = handler
        return new
    }
}
