//
//  ExerciseRunningScene.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 07.11.2022.
//

import SwiftUI

struct WorkOutRunScene: View {
    @StateObject var viewModel: WorkOutRunViewModel

    var onQuitTab: (() -> Void)?

    var body: some View {
        BaseView(
            header: {
                TitleText(text: viewModel.workoutName, alignment: .center)
            },
            content: {
                WorkOutRunContent()
                    .environmentObject(viewModel)
            },
            footer: {
                WorkOutRunFooter()
                    .onQuitTab { performAction(onQuitTab) }
                    .environmentObject(viewModel)
            }
        )
    }
}

struct WorkOutRunScene_Previews: PreviewProvider {
    static var previews: some View {
        WorkOutRunScene(viewModel: WorkOutRunViewModel(
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
