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
    @EnvironmentObject var router: ViewRouter

    @State var isModalActive = false
    @State var activeSheetType: ActivityType?

    var body: some View {
        BaseView(
            header: {
                WorkOutHeader()
                    .onSaveTab { isModalActive = true }
            },
            content: {
                WorkOutContent()
                    .onTab { self.activeSheetType = $0 }
                    .onStartTab {
                        router.currentTab = .workoutRun
                    }
            },
            footer: {
                MenuBar(activeTab: router.currentTab)
                    .onRouteTab { router.currentTab = $0 }
            }
        )
        .fullScreenCover(isPresented: $isModalActive, content: {
            WorkOutEditScene(name: viewModel.name, work: viewModel.work, rest: viewModel.rest, series: viewModel.series,
                             rounds: viewModel.rounds, reset: viewModel.reset)
                .onCloseTab { newObjectId in
                    if newObjectId != nil {
                        viewModel.loadWorkoutById(newObjectId!)
                    }
                    isModalActive = false
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
}

struct WorkOutScene_Previews: PreviewProvider {
    static var previews: some View {
        WorkOutScene()
            .environmentObject(WorkOutViewModel())
            .environmentObject(ViewRouter())
            .environmentObject(AppStorageManager())
    }
}
