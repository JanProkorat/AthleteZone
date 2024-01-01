//
//  TrainingRunScene.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 30.03.2023.
//

import RealmSwift
import SwiftUI

struct TrainingRunScene: View {
    @StateObject var viewModel: TrainingRunViewModel

    var body: some View {
        RunBaseView {
            TitleText(text: viewModel.trainingName, alignment: .center)
        } content: {
            TrainingRunContent()
                .environmentObject(viewModel.selectedWorkFlowViewModel)
        } footer: {
            TrainingRunFooter()
                .environmentObject(viewModel.selectedWorkFlowViewModel)
        }
    }
}

#Preview {
    let viewModeel = TrainingRunViewModel()
    viewModeel.setupViewModel(
        trainingName: "name",
        workouts: [
            WorkOut("Prvni", 2, 2, 2, 2, 2),
            WorkOut("Druhy", 2, 2, 2, 2, 2)
        ]
    )
    return TrainingRunScene(viewModel: viewModeel)
}
