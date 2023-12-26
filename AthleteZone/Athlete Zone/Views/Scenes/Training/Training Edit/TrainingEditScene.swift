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
        VStack {
            TitleText(text: viewModel.isEditing ? LocalizationKey.editTraining.rawValue :
                LocalizationKey.addTraining.rawValue, alignment: .center)
                .padding([.leading, .trailing], 10)
                .frame(maxWidth: .infinity)

            TrainingEditContent(isModalVisible: $isModalVisible)
                .padding([.leading, .trailing], 10)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.top, -10)

            TrainingEditFooter()
                .onCloseTab { performAction(self.onCloseTab) }
                .onSaveTab {
                    viewModel.saveTraining()
                    performAction(self.onCloseTab)
                }
                .padding([.leading, .trailing], 10)
                .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color(ComponentColor.darkBlue.rawValue))
        .environment(\.colorScheme, .dark)
        .ignoresSafeArea(.keyboard, edges: [.bottom])
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
