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
        .fullScreenCover(isPresented: $isRunViewVisible, content: {
            WorkOutRunScene(viewModel: viewModel.runViewModel)
        })
        .sheet(item: $activeSheetType) { activitySheet in
            switch activitySheet {
            case .work:
                IntervalPicker(title: activitySheet.rawValue, color: .lightPink) {
                    TimePicker(textColor: ComponentColor.lightPink, interval: $viewModel.work)
                }
                .presentationDetents([.fraction(0.4)])

            case .rest:
                IntervalPicker(title: activitySheet.rawValue, color: .lightYellow) {
                    TimePicker(textColor: ComponentColor.lightYellow, interval: $viewModel.rest)
                }
                .presentationDetents([.fraction(0.4)])

            case .series:
                IntervalPicker(title: activitySheet.rawValue, color: .lightBlue) {
                    NumberPicker(textColor: ComponentColor.lightBlue, value: $viewModel.series)
                }
                .presentationDetents([.fraction(0.4)])

            case .rounds:
                IntervalPicker(title: activitySheet.rawValue, color: .lightGreen) {
                    NumberPicker(textColor: ComponentColor.lightGreen, value: $viewModel.rounds)
                }
                .presentationDetents([.fraction(0.4)])

            case .reset:
                IntervalPicker(title: activitySheet.rawValue, color: .braun) {
                    TimePicker(textColor: ComponentColor.braun, interval: $viewModel.reset)
                }
                .presentationDetents([.fraction(0.4)])
            }
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
        WorkOutScene(isRunViewVisible: .constant(false))
            .environmentObject(WorkOutViewModel())
    }
}
