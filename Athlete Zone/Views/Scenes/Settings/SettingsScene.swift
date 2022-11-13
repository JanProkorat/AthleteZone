//
//  SettingsView.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 07.11.2022.
//

import SwiftUI

struct SettingsScene: View {
    
    @StateObject var router: ViewRouter

    var body: some View {
        SceneView(header: AnyView(SettingsHeaderBar()),
                  content: AnyView(SettingsContent()), isFooterVisible: true,
                  router: router)
    }
}

struct SettingsScene_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScene(router: ViewRouter(currentTab: .setting))
    }
}
