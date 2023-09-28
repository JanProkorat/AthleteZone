//
//  TrainingRunView.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 24.08.2023.
//

import SwiftUI

struct TrainingRunView: View {
    @EnvironmentObject var viewModel: TrainingRunViewModel
    var onQuitTab: (() -> Void)?
    @State var selectedTab = 1

    var body: some View {
        TabView(selection: $selectedTab) {
            WorkoutLibraryTab()
                .onWorkoutSelect { selectedTab = 1 }
                .environmentObject(viewModel.selectedWorkFlowViewModel)
                .tag(0)

            WorkOutRunContent()
                .environmentObject(viewModel.selectedWorkFlowViewModel)
                .tag(1)

            WorkOutActions()
                .onTab { selectedTab = 1 }
                .environmentObject(viewModel.selectedWorkFlowViewModel)
                .tag(2)
        }
        .onChange(of: viewModel.closeSheet) { _ in
            self.viewModel.closeSheet.toggle()
            self.performAction(onQuitTab)
        }
    }
}

struct TrainingRunView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = TrainingRunViewModel()
        viewModel.setupViewModel(
            trainingName: "name",
            workouts: [
                WorkOut("Prvni", 2, 2, 2, 2, 2),
                WorkOut("Druhy", 3, 3, 3, 3, 3)
            ]
        )
        return TrainingRunView()
            .environmentObject(viewModel)
    }
}

extension TrainingRunView {
    func onQuitTab(_ handler: @escaping () -> Void) -> TrainingRunView {
        var new = self
        new.onQuitTab = handler
        return new
    }
}
