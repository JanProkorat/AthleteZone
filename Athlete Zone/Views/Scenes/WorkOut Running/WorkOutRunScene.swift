//
//  ExerciseRunningScene.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 07.11.2022.
//

import SwiftUI

struct WorkOutRunScene: View {
    @EnvironmentObject var router: ViewRouter
    @EnvironmentObject var viewModel: WorkOutViewModel
    @StateObject var workFlowViewModel = WorkFlowViewModel()

    @State var isRunning = true

    var body: some View {
        BaseView(
            header: {
                WorkOutRunHeader(title: viewModel.selectedWorkOut!.name)
            },
            content: {
                WorkOutRunContent()
                    .onQuitTab { router.currentTab = .home }
                    .onIsRunningChange {
                        isRunning.toggle()
                    }
                    .environmentObject(workFlowViewModel)
            },
            footer: {
                WorkOutRunFooter(isRunning: isRunning)
                    .onQuitTab { router.currentTab = .home }
                    .environmentObject(workFlowViewModel)
            }
        )
        .onAppear {
            workFlowViewModel.createWorkFlow(workOut: viewModel.selectedWorkOut!)
        }
    }
}

struct WorkOutRunScene_Previews: PreviewProvider {
    static var previews: some View {
        WorkOutRunScene()
            .environmentObject(ViewRouter())
            .environmentObject(WorkOutViewModel(selectedWorkOut: WorkOut()))
            .environment(\.locale, .init(identifier: "cze"))
    }
}
