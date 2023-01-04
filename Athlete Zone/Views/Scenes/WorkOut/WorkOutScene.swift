//
//  ContentView.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 03.11.2022.
//

import RealmSwift
import SwiftUI

struct WorkOutScene: View {
    @AppStorage(DefaultItem.selectedWorkoutId.rawValue) private var selectedItemId: String = ""
    @Environment(\.scenePhase) var scenePhase

    @EnvironmentObject var viewModel: WorkOutViewModel
    @EnvironmentObject var router: ViewRouter

    @State var isModalActive = false
    @State var name = ""
    @State var work = 0
    @State var rest = 0
    @State var series = 0
    @State var rounds = 0
    @State var reset = 0

    @State var activeSheetType: ActivityType?

    var body: some View {
        BaseView(
            header: {
                WorkOutHeader(name)
                    .onSaveTab { isModalActive = true }
            },
            content: {
                WorkOutContent(work, rest, series, rounds, reset)
                    .onTab { self.activeSheetType = $0 }
                    .onStartTab { router.currentTab = .workoutRun }
            },
            footer: {
                MenuBar(activeTab: router.currentTab)
                    .onRouteTab { router.currentTab = $0 }
            }
        )
        .onAppear { setValues() }
        .onChange(of: scenePhase) { newPhase in
            if (newPhase == .inactive || newPhase == .background) && viewModel.selectedWorkOut != nil {
                selectedItemId = viewModel.selectedWorkOut!._id.stringValue
            }
        }
        .onChange(of: isModalActive, perform: { newValue in
            if !newValue {
                setValues()
            }
        })
        .fullScreenCover(isPresented: $isModalActive, content: {
            WorkOutEditScene(name, work, rest, series, rounds, reset, .constant(false))
                .onCloseTab { isModalActive = false }
                .onSaveTab { value in
                    viewModel.saveWorkOut(value)
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
                    TimePicker(textColor: ComponentColor.work.rawValue, interval: work)
                        .onValueChange { work = $0 }

                case .rest:
                    TimePicker(textColor: ComponentColor.rest.rawValue, interval: rest)
                        .onValueChange { rest = $0 }

                case .series:
                    NumberPicker(textColor: ComponentColor.series.rawValue, value: series)
                        .onValueChange { series = $0 }

                case .rounds:
                    NumberPicker(textColor: ComponentColor.rounds.rawValue, value: rounds)
                        .onValueChange { rounds = $0 }

                case .reset:
                    TimePicker(textColor: ComponentColor.reset.rawValue, interval: reset)
                        .onValueChange { reset = $0 }
                }
            }
        }
    }
}

struct WorkOutScene_Previews: PreviewProvider {
    static var previews: some View {
        WorkOutScene()
            .environmentObject(WorkOutViewModel())
            .environmentObject(ViewRouter())
    }
}

extension WorkOutScene {
    func setValues() {
        var selectedWorkout: WorkOut?
        if let workout = viewModel.selectedWorkOut {
            selectedWorkout = workout
        } else if !selectedItemId.isEmpty {
            do {
                let dbWorkout = try viewModel.loadWorkoutById(ObjectId(string: selectedItemId))
                if let workout = dbWorkout {
                    selectedWorkout = workout
                    viewModel.setSelectedWorkOut(selectedWorkout!)
                } else {
                    selectedWorkout = WorkOut()
                }
            } catch {
                print(error.localizedDescription)
            }
        } else {
            selectedWorkout = WorkOut()
            viewModel.setSelectedWorkOut(selectedWorkout!)
        }
        name = selectedWorkout!.name
        work = selectedWorkout!.work
        rest = selectedWorkout!.rest
        series = selectedWorkout!.series
        rounds = selectedWorkout!.rounds
        reset = selectedWorkout!.reset
    }
}
