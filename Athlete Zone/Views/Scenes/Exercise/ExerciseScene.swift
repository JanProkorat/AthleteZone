//
//  ContentView.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 03.11.2022.
//

import SwiftUI

struct ExerciseScene: View {
        
    @StateObject var router: ViewRouter
//    @StateObject var viewModel = ViewModel()
    @StateObject private var workout: WorkOut = WorkOut()
    
    var body: some View {
        SceneView(
            header: AnyView(ExerciseHeaderBar()),
            content: AnyView(ExerciseContent(workout: workout)
                .onStartTab{
                    router.currentTab = .exerciseRun
                }),
            isFooterVisible: true,
            router: router)
    }
}

struct ExerciseScene_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseScene(router: ViewRouter(currentTab: .home))
    }
}
