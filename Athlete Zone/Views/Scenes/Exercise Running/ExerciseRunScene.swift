//
//  ExerciseRunningScene.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 07.11.2022.
//

import SwiftUI

struct ExerciseRunScene: View {
    @EnvironmentObject var router: ViewRouter
    @EnvironmentObject var viewModel: WorkOutViewModel

    var body: some View {
        SceneView(
            header: AnyView(
                ExerciseRunHeaderBar(
                    title: viewModel.selectedWorkOut.name
                )
            ),
            content: AnyView(
                ExerciseRunContent(
                    workOut: viewModel.selectedWorkOut
                )
                .onQuitTab {
                    router.currentTab = .home
                }
            ),
            footer: nil
        )
    }
}

struct ExerciseRunScene_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseRunScene()
            .environmentObject(ViewRouter())
            .environmentObject(WorkOutViewModel())
    }
}
