//
//  ContentView.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 03.11.2022.
//

import RealmSwift
import SwiftUI

struct WorkOutScene: View {
    @EnvironmentObject var viewModel: WorkOutViewModel

    @State var isEditModalActive = false
    @Binding var isRunViewVisible: Bool

    @State var activeSheetType: ActivityType?

    var body: some View {
        BaseView(
            header: {
                WorkOutHeader()
                    .onSaveTab { isEditModalActive.toggle() }
            },
            content: {
                WorkOutContent()
                    .onTab { self.activeSheetType = $0 }
                    .onStartTab { viewModel.setupRunViewModel() }
            }
        )
        .sheet(isPresented: $isEditModalActive, content: {
            WorkOutEditScene()
                .onCloseTab { isEditModalActive.toggle() }
                .environmentObject(getViewModel())

        })
        .fullScreenCover(isPresented: $isRunViewVisible, content: {
            WorkOutRunScene(viewModel: viewModel.runViewModel)
        })
        .sheet(item: $activeSheetType) { activitySheet in
            IntervalPicker(type: $activeSheetType, interval: getInterval(activitySheet))
                .presentationDetents([.fraction(0.5)])
        }
    }

    private func getViewModel() -> WorkOutEditViewModel {
        if let workout = viewModel.selectedWorkout {
            return WorkOutEditViewModel(
                workout: workout,
                viewModel.work,
                viewModel.rest,
                viewModel.series,
                viewModel.rounds,
                viewModel.reset
            )
        }
        return WorkOutEditViewModel(
            viewModel.work,
            viewModel.rest,
            viewModel.series,
            viewModel.rounds,
            viewModel.reset
        )
    }

    private func getInterval(_ type: ActivityType) -> Binding<Int> {
        switch type {
        case .work:
            return $viewModel.work

        case .rest:
            return $viewModel.rest

        case .series:
            return $viewModel.series

        case .rounds:
            return $viewModel.rounds

        case .reset:
            return $viewModel.reset
        }
    }
}

struct WorkOutScene_Previews: PreviewProvider {
    static var previews: some View {
        WorkOutScene(isRunViewVisible: .constant(false))
            .environmentObject(WorkOutViewModel())
    }
}
