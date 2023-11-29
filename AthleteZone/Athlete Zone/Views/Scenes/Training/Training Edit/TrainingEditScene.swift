//
//  TrainingEditScene.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 09.07.2023.
//

import SwiftUI

struct TrainingEditScene: View {
    @EnvironmentObject var viewModel: TrainingEditViewModel
    @State var isModalVisible = false

    var onCloseTab: (() -> Void)?

    var body: some View {
        BaseView {
            TitleText(text: viewModel.isEditing ? LocalizationKey.editTraining.rawValue :
                LocalizationKey.addTraining.rawValue, alignment: .center)
        } content: {
            TrainingEditContent(isModalVisible: $isModalVisible)
        } footer: {
            TrainingEditFooter()
                .onCloseTab { performAction(self.onCloseTab) }
                .onSaveTab {
                    viewModel.saveTraining()
                    performAction(self.onCloseTab)
                }
        }
        .sheet(isPresented: $isModalVisible) {
            WorkoutPicker(
                selectedWorkouts: $viewModel.workouts,
                workoutLibrary: viewModel.workoutRealmManager.load()
            )
        }
    }
}

struct TrainingEditScene_Previews: PreviewProvider {
    static var previews: some View {
        TrainingEditScene()
            .environmentObject(TrainingEditViewModel())
    }
}

extension TrainingEditScene {
    func onCloseTab(_ handler: @escaping () -> Void) -> TrainingEditScene {
        var new = self
        new.onCloseTab = handler
        return new
    }
}
