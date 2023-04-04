//
//  ExerciseRunningScene.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 07.11.2022.
//

import SwiftUI

struct WorkOutRunScene: View {
    @EnvironmentObject var router: ViewRouter
    @EnvironmentObject var viewModel: WorkFlowViewModel

    var body: some View {
        BaseView(
            header: {
                WorkOutRunHeader(title: viewModel.workoutName)
            },
            content: {
                WorkOutRunContent()
                    .onQuitTab {
                        viewModel.onQuitTab()
                        router.currentTab = .home
                    }
            },
            footer: {
                WorkOutRunFooter()
                    .onQuitTab {
                        viewModel.onQuitTab()
                        router.currentTab = .home
                    }
            }
        )
        .onChange(of: viewModel.state) { newValue in
            switch newValue {
            case .running:
                UIApplication.shared.isIdleTimerDisabled = true

            default:
                UIApplication.shared.isIdleTimerDisabled = false
            }
        }
    }
}

struct WorkOutRunScene_Previews: PreviewProvider {
    static var previews: some View {
        WorkOutRunScene()
            .environmentObject(ViewRouter())
            .environmentObject(WorkFlowViewModel())
            .environment(\.locale, .init(identifier: "cze"))
    }
}
