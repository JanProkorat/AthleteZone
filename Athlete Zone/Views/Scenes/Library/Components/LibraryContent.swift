//
//  LibraryContent.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 07.11.2022.
//

import SwiftUI
import RealmSwift

struct LibraryContent: View {
    
    @EnvironmentObject var viewModel: WorkOutViewModel
    @EnvironmentObject var router: ViewRouter
    
    var onEditTab: (() -> Void)?

    init(){
        UICollectionView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        List(viewModel.workOutLibrary) { workout in
            Button {
                self.viewModel.setSelectedWorkOut(workout)
                self.router.currentTab = .home
            } label: {
                WorkOutListView(workOut: workout)
                    .onDeleteTab {
                        viewModel.delete(entityKey: workout._id!)
                    }
                    .onEditTab {
                        viewModel.setWorkOutToEdit(workout)
                        if self.onEditTab != nil {
                            self.onEditTab!()
                        }
                    }
            }
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .background(Color(Backgrounds.Background))
        }
        .listStyle(.plain)
        .onAppear(){
            self.viewModel.workOutLibrary = viewModel.load()
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
    func onEditTab(_ handler: @escaping () -> Void) -> LibraryContent {
        var new = self
        new.onEditTab = handler
        return new
    }
}
