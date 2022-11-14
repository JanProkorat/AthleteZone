//
//  ProfileView.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 07.11.2022.
//

import SwiftUI

struct ProfileScene: View {
        
    var body: some View {
        SceneView(header: AnyView(ProfileHeaderBar()),
                  content: AnyView(LibraryContent()), isFooterVisible: true)
    }
}

struct ProfileScene_Previews: PreviewProvider {
    static var previews: some View {
        ProfileScene()
    }
}
