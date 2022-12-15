//
//  SettingsView.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 07.11.2022.
//

import SwiftUI

struct SettingsScene: View {
    @EnvironmentObject var router: ViewRouter

    var body: some View {
        SceneView(
            header: AnyView(SettingsHeaderBar()),
            content: AnyView(SettingsContent()),
            footer: AnyView(
                MenuBar(activeTab: router.currentTab)
                    .onRouteTab { router.currentTab = $0 }
            )
        )
    }
}

struct SettingsScene_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScene()
            .environmentObject(ViewRouter())
    }
}
