//
//  ExerciseRunningScene.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 07.11.2022.
//

import SwiftUI

struct ExerciseRunScene: View {
        
    let workOut: WorkOut = WorkOut()
    @EnvironmentObject var router: ViewRouter

    var body: some View {
        SceneView(header: AnyView(ExerciseRunHeaderBar(title: workOut.name)),
                  content: AnyView(ExerciseRunContent().onQuitTab{
            router.currentTab = .home
        }), isFooterVisible: false)
    }
}

struct ExerciseRunScene_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseRunScene()
            .environmentObject(ViewRouter())
    }
}
