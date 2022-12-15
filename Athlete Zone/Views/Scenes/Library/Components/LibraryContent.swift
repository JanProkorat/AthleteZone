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
    @EnvironmentObject var viewModel: WorkOutViewModel
    @EnvironmentObject var router: ViewRouter
    @ObservedResults(WorkOut.self, sortDescriptor: SortDescriptor(keyPath: "name", ascending: true)) var workOutLibrary

    var onEditTab: ((_ workOut: WorkOut) -> Void)?

    init() {
        UICollectionView.appearance().backgroundColor = UIColor(Color(Backgrounds.Background))
    }

    var body: some View {
        if !workOutLibrary.isEmpty {
            NavigationView {
                List(workOutLibrary, id: \._id) { workout in
                    Button {
                        self.viewModel.setSelectedWorkOut(workout)
                        self.router.currentTab = .home
                    } label: {
                        WorkOutListView(workOut: workout)
                            .onDeleteTab {
                                $workOutLibrary.remove(workout)
                            }
                            .onEditTab {
                                self.performAction(onEditTab, value: workout.thaw()!)
                            }
                    }
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .background(Color(Backgrounds.Background))
                }
                .listStyle(.plain)
                .searchable(text: $searchText, collection: $workOutLibrary, keyPath: \.name, prompt: "Search name...")
            }
            .background(Color(Backgrounds.Background))
        } else {
            Text("No workouts to display jet.")
                .font(.custom("Lato-Black", size: 20))
                .bold()
                .foregroundColor(Color(Colors.MainText))
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
