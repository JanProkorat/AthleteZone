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
    var footer: AnyView?

    @EnvironmentObject var router: ViewRouter

    var body: some View {
        GeometryReader { _ in
            VStack(spacing: 0) {
                header
                    .frame(maxHeight: 45)
                    .padding([.leading, .trailing], 10)
                content
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                footer
            }
            .background(Color(Backgrounds.Background))
            .animation(Animation.easeInOut(duration: 0.2), value: router.currentTab)
        }
    }
}

struct SceneView_Previews: PreviewProvider {
    static var previews: some View {
        SceneView(
            header: AnyView(WorkOutHeader("name")),
            content: AnyView(WorkOutContent(60, 40, 4, 2, 60)),
            footer: AnyView(MenuBar(activeTab: .home))
        )
        .environmentObject(ViewRouter())
    }
}
