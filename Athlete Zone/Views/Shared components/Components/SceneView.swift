//
//  SceneView.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 07.11.2022.
//

import SwiftUI

struct SceneView: View {
    var header: AnyView
    var content: AnyView

    var isFooterVisible: Bool
    @EnvironmentObject var router: ViewRouter

    var body: some View {
        GeometryReader { _ in
            VStack(spacing: 5) {
                // Header
                header
                    .frame(maxHeight: 45)
                    .padding([.leading, .trailing], 10)
                // Body
                content
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                // Footer
                if isFooterVisible {
                    MenuBar(activeTab: router.currentTab)
                        .onHomeTab {
                            router.currentTab = .home
                        }
                        .onLibraryTab {
                            router.currentTab = .library
                        }
                        .onProfileTab {
                            router.currentTab = .profile
                        }
                        .onSettingsTab {
                            router.currentTab = .setting
                        }
                }
            }
            .background(Color(Backgrounds.Background))
            .animation(Animation.easeInOut(duration: 0.2), value: router.currentTab)
        }
    }
}

struct SceneView_Previews: PreviewProvider {
    static var previews: some View {
        SceneView(header: AnyView(ExerciseHeaderBar(name: "name")),
                  content: AnyView(ExerciseContent()), isFooterVisible: true)
            .environmentObject(ViewRouter())
    }
}
