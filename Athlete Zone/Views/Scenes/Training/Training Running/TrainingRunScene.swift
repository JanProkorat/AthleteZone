//
//  TrainingRunScene.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 30.03.2023.
//

import RealmSwift
import SwiftUI

struct TrainingRunScene: View {
    @EnvironmentObject var viewModel: TrainingRunViewModel

    var onQuitTab: (() -> Void)?

    var body: some View {
        BaseView {
            TrainingRunHeader(title: viewModel.trainingName)
        } content: {
            TrainingRunContent()
                .environmentObject(viewModel.selectedWorkFlowViewModel)
        } footer: {
            TrainingRunFooter()
                .onQuitTab {
                    performAction(onQuitTab)
                }
                .environmentObject(viewModel.selectedWorkFlowViewModel)
        }
    }
}

struct TrainingRunScene_Previews: PreviewProvider {
    static var previews: some View {
        let workouts = RealmSwift.List<WorkOut>()
        workouts.append(objectsIn: [
            WorkOut("Prvni", 2, 2, 2, 2, 2),
            WorkOut("Druhy", 2, 2, 2, 2, 2)
        ])
        return TrainingRunScene()
            .environmentObject(TrainingRunViewModel(
                training: Training(
                    name: "test",
                    description: "",
                    workouts: workouts
                )
            ))
    }
}

extension TrainingRunScene {
    func onQuitTab(_ handler: @escaping () -> Void) -> TrainingRunScene {
        var new = self
        new.onQuitTab = handler
        return new
    }
}
