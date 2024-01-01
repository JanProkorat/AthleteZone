//
//  ExerciseRunningScene.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 07.11.2022.
//

import SwiftUI

struct WorkOutRunScene: View {
    @StateObject var viewModel: PhoneWorkOutRunViewModel

    var body: some View {
        RunBaseView(
            header: {
                TitleText(text: viewModel.workoutName, alignment: .center)
            },
            content: {
                WorkOutRunContent()
                    .environmentObject(viewModel)
            },
            footer: {
                WorkOutRunFooter()
                    .environmentObject(viewModel)
            }
        )
    }
}

struct WorkOutRunScene_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = PhoneWorkOutRunViewModel()
        viewModel.setupViewModel(workout: WorkOut("Title", 30, 60, 2, 1, 120))
        return WorkOutRunScene(viewModel: viewModel)
            .environment(\.locale, .init(identifier: "cze"))
    }
}
