//
//  LibraryView.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 05.11.2022.
//

import SwiftUI

struct LibraryScene: View {
    @State var isModalActive = false

    var body: some View {
        SceneView(header: AnyView(LibraryHeaderBar()),
                  content: AnyView(LibraryContent().onEditTab {
                      isModalActive = true
                  }), isFooterVisible: true)
            .fullScreenCover(isPresented: $isModalActive, content: {
                ExerciseEditScene().onCloseTab {
                    isModalActive = false
                }
            })
    }
}

struct LibraryScene_Previews: PreviewProvider {
    static var previews: some View {
        LibraryScene()
            .environmentObject(WorkOutViewModel())
            .environmentObject(ViewRouter())
    }
}
