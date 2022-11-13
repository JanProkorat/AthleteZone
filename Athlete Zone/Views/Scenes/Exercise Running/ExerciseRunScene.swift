//
//  ExerciseRunningScene.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 07.11.2022.
//

import SwiftUI

struct ExerciseRunScene: View {
    
    @StateObject var router: ViewRouter
    
    let workOut: WorkOut = WorkOut()

    var body: some View {
        SceneView(header: AnyView(ExerciseRunHeaderBar(title: workOut.name)),
                  content: AnyView(ExerciseRunContent().onQuitTab{
            router.currentTab = .home
        }), isFooterVisible: false, router: router)
    }
}

struct ExerciseRunScene_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseRunScene(router: ViewRouter(currentTab: .exerciseRun))
    }
}
