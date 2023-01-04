//
//  LibraryContent.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 07.11.2022.
//

import RealmSwift
import SwiftUI

struct LibraryContent: View {
    @State private var searchText = ""
    @State private var sortOrder: SortOrder = .ascending
    @State private var sortBy: SortByProperty = .name
    @State private var sortDescriptor = SortDescriptor(\WorkOut.name, order: .forward)
    @EnvironmentObject var viewModel: WorkOutViewModel
    @EnvironmentObject var router: ViewRouter
    @ObservedResults(WorkOut.self, sortDescriptor: SortDescriptor(keyPath: "name", ascending: true)) var workOutLibrary

    var onEditTab: ((_ workOut: WorkOut) -> Void)?

    init() {
        UICollectionView.appearance().backgroundColor = UIColor(Color(Background.background.rawValue))
    }

    var body: some View {
        VStack {
            SearchBar(text: $searchText)
                .padding(5)
            HStack {
                SortByPicker()
                    .onPropertySelected { sortBy = $0 }
                SortOrderPicker()
                    .onOrderSelected { sortOrder = $0 }
            }
            .padding([.leading, .trailing], 5)
            .padding(.bottom, 10)
            let library = searchText.isEmpty ?
                workOutLibrary.sorted(using: sortDescriptor) :
                workOutLibrary
                .where { $0.name.contains(searchText) }
                .sorted(using: sortDescriptor)
            if !library.isEmpty {
                List(library, id: \._id) { workout in
                    Button {
                        self.viewModel.setSelectedWorkOut(workout)
                        self.router.currentTab = .home
                    } label: {
                        WorkOutListView(workOut: workout)
                            .onDeleteTab {
                                if viewModel.selectedWorkOut!._id == workout._id {
                                    viewModel.setSelectedWorkOut(nil)
                                }
                                $workOutLibrary.remove(workout)
                            }
                            .onEditTab {
                                self.performAction(onEditTab, value: workout.thaw()!)
                            }
                    }
                    .padding(.bottom, 150)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .background(Color(Background.background.rawValue))
                }
                .listStyle(.plain)
            } else {
                Text("No workouts to display.")
                    .font(.custom("Lato-Black", size: 20))
                    .bold()
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .onChange(of: sortOrder) { newValue in
            sortDescriptor.order = newValue == .ascending ? .forward : .reverse
        }
        .onChange(of: self.sortBy) { newValue in
            switch newValue {
            case .name:
                sortDescriptor = SortDescriptor(\WorkOut.name, order: sortDescriptor.order)

            case .work:
                sortDescriptor = SortDescriptor(\WorkOut.work, order: sortDescriptor.order)

            case .rest:
                sortDescriptor = SortDescriptor(\WorkOut.rest, order: sortDescriptor.order)

            case .series:
                sortDescriptor = SortDescriptor(\WorkOut.series, order: sortDescriptor.order)

            case .rounds:
                sortDescriptor = SortDescriptor(\WorkOut.rounds, order: sortDescriptor.order)

            case .reset:
                sortDescriptor = SortDescriptor(\WorkOut.reset, order: sortDescriptor.order)

            case .createdDate:
                sortDescriptor = SortDescriptor(\WorkOut.createdDate, order: sortDescriptor.order)

            case .workoutLength:
                sortDescriptor = SortDescriptor(\WorkOut.timeOverview, order: sortDescriptor.order)
            }
        }
    }
}

struct LibraryContent_Previews: PreviewProvider {
    static var previews: some View {
        LibraryContent()
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
