//
//  LibraryView.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 05.11.2022.
//

import SwiftUI

struct LibraryScene: View {
    
    var body: some View {
        SceneView(header: AnyView(LibraryHeaderBar()),
                  content: AnyView(LibraryContent()), isFooterVisible: true)
        
    }
}

struct LibraryScene_Previews: PreviewProvider {
    static var previews: some View {
        LibraryScene()
    }
}
