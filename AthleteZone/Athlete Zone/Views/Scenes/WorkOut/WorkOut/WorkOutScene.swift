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
    @State var isRunModalActive = false

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
                    .onStartTab { isRunModalActive.toggle() }
            },
            footer: {
                MenuBar(activeTab: viewModel.router.currentTab)
                    .onRouteTab { viewModel.router.currentTab = $0 }
            }
        )
        .fullScreenCover(isPresented: $isEditModalActive, content: {
            WorkOutEditScene()
                .onCloseTab { isEditModalActive.toggle() }
                .environmentObject(getViewModel())

        })
        .fullScreenCover(isPresented: $isRunModalActive, content: {
            WorkOutRunScene(viewModel: WorkOutRunViewModel(
                workout: WorkOut(
                    viewModel.name,
                    viewModel.work,
                    viewModel.rest,
                    viewModel.series,
                    viewModel.rounds,
                    viewModel.reset
                )
            ))
            .onQuitTab {
                isRunModalActive.toggle()
            }
        })
        .sheet(item: $activeSheetType) { activitySheet in
            IntervalPicker(
                title: activitySheet.rawValue,
                color: ComponentColor.allCases.first(where: { activitySheet.rawValue.contains($0.rawValue) })!,
                backgroundColor: Background.allCases.first(where: { $0.rawValue.contains(activitySheet.rawValue) })!
            ) {
                switch activitySheet {
                case .work:
                    TimePicker(textColor: ComponentColor.work, interval: $viewModel.work)

                case .rest:
                    TimePicker(textColor: ComponentColor.rest, interval: $viewModel.rest)

                case .series:
                    NumberPicker(textColor: ComponentColor.series, value: $viewModel.series)

                case .rounds:
                    NumberPicker(textColor: ComponentColor.rounds, value: $viewModel.rounds)

                case .reset:
                    TimePicker(textColor: ComponentColor.reset, interval: $viewModel.reset)
                }
            }
            .presentationDetents([.fraction(0.4)])
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
}

struct WorkOutScene_Previews: PreviewProvider {
    static var previews: some View {
        WorkOutScene()
            .environmentObject(WorkOutViewModel())
    }
}
