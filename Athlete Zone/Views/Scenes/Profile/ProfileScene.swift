//
//  ProfileView.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 07.11.2022.
//

import SwiftUI

struct ProfileScene: View {
    @EnvironmentObject var router: ViewRouter

    var body: some View {
        BaseView {
            ProfileHeaderBar()
        } content: {
            LibraryContent()
        } footer: {
            MenuBar(activeTab: router.currentTab)
                .onRouteTab { router.currentTab = $0 }
        }
    }
}

struct ProfileScene_Previews: PreviewProvider {
    static var previews: some View {
        ProfileScene()
    }
}
