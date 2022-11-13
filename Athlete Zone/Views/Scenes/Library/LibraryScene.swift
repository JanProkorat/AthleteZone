//
//  LibraryView.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 05.11.2022.
//

import SwiftUI

struct LibraryScene: View {
    
    @StateObject var router: ViewRouter

    var body: some View {
        SceneView(header: AnyView(LibraryHeaderBar()),
                  content: AnyView(LibraryContent()), isFooterVisible: true,
                  router: router)
        
    }
}

struct LibraryScene_Previews: PreviewProvider {
    static var previews: some View {
        LibraryScene(router: ViewRouter(currentTab: .library))
    }
}
