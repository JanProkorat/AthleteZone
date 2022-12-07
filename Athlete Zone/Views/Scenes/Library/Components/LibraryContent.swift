//
//  LibraryContent.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 07.11.2022.
//

import RealmSwift
import SwiftUI

struct LibraryContent: View {
    @EnvironmentObject var viewModel: WorkOutViewModel
    @EnvironmentObject var router: ViewRouter

    var onEditTab: (() -> Void)?

    init() {
        UICollectionView.appearance().backgroundColor = .clear
    }

    var body: some View {
        VStack {
            if let library = viewModel.workOutLibrary {
                List(library) { workout in
                    Button {
                        self.viewModel.setSelectedWorkOut(workout)
                        self.router.currentTab = .home
                    } label: {
                        WorkOutListView(workOut: workout)
                            .onDeleteTab {
                                viewModel.delete(workout)
                                self.viewModel.workOutLibrary = viewModel.load()
                            }
                            .onEditTab {
                                viewModel.setWorkOutToEdit(workout)
                                self.performAction(onEditTab)
                            }
                    }
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .background(Color(Backgrounds.Background))
                }
                .listStyle(.plain)
                .overlay(Group {
                    if self.viewModel.workOutLibrary != nil && self.viewModel.workOutLibrary!.isEmpty {
                        text
                    }
                })
            } else {
                text
            }
        }
        .onAppear {
            self.viewModel.workOutLibrary = viewModel.load()
        }
    }

    @ViewBuilder
    var text: some View {
        Text("No workouts to display jet.")
            .font(.custom("Lato-Black", size: 20))
            .bold()
            .foregroundColor(Color(Colors.MainText))
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
    func onEditTab(_ handler: @escaping () -> Void) -> LibraryContent {
        var new = self
        new.onEditTab = handler
        return new
    }
}
