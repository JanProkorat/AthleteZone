//
//  ExerciseRunningScene.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 07.11.2022.
//

import SwiftUI

struct WorkOutRunScene: View {
    @EnvironmentObject var viewModel: WorkFlowViewModel

    var onQuitTab: (() -> Void)?

    var body: some View {
        BaseView(
            header: {
                WorkOutRunHeader(title: viewModel.workoutName)
            },
            content: {
                WorkOutRunContent()
            },
            footer: {
                WorkOutRunFooter()
                    .onQuitTab { performAction(onQuitTab) }
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
            .environmentObject(WorkFlowViewModel(
                workout: WorkOut("Prvni", 2, 2, 2, 2, 2)
            ))
            .environment(\.locale, .init(identifier: "cze"))
    }
}

extension WorkOutRunScene {
    func onQuitTab(_ handler: @escaping () -> Void) -> WorkOutRunScene {
        var new = self
        new.onQuitTab = handler
        return new
    }
}
