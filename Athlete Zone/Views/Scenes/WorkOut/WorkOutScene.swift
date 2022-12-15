//
//  ContentView.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 03.11.2022.
//

import SwiftUI

struct WorkOutScene: View {
    @EnvironmentObject var viewModel: WorkOutViewModel
    @EnvironmentObject var router: ViewRouter

    @State var isModalActive = false
    @State var name = ""
    @State var work = 0
    @State var rest = 0
    @State var series = 0
    @State var rounds = 0
    @State var reset = 0

    var body: some View {
        SceneView(
            header: AnyView(
                WorkOutHeader(name)
                    .onSaveTab {
                        isModalActive = true
                    }
            ),
            content: AnyView(WorkOutContent(work, rest, series, rounds, reset)),
            footer: AnyView(
                MenuBar(activeTab: router.currentTab)
                    .onRouteTab { router.currentTab = $0 }
            )
        )
        .onAppear { setValues() }
        .onChange(of: isModalActive, perform: { newValue in
            if !newValue {
                setValues()
            }
        })
        .fullScreenCover(isPresented: $isModalActive, content: {
            WorkOutEditScene(name, work, rest, series, rounds, reset)
                .onCloseTab { isModalActive = false }
                .onSaveTab { value in
                    viewModel.saveWorkOut(value)
                    isModalActive = false
                }
        })
        .sheet(item: $router.activeHomeSheet) { activitySheet in
            switch activitySheet {
            case .work:
                ActivityPicker(
                    title: "Work",
                    color: Colors.Work,
                    backgroundColor: Backgrounds.WorkBackground,
                    picker: AnyView(
                        TimePicker(textColor: Colors.Work, interval: work)
                            .onValueChange { work = $0 }
                    )
                )

            case .rest:
                ActivityPicker(
                    title: "Rest",
                    color: Colors.Rest,
                    backgroundColor: Backgrounds.RestBackground,
                    picker: AnyView(
                        TimePicker(textColor: Colors.Rest, interval: rest)
                            .onValueChange { rest = $0 }
                    )
                )

            case .series:
                ActivityPicker(
                    title: "Series",
                    color: Colors.Series,
                    backgroundColor: Backgrounds.SeriesBackground,
                    picker: AnyView(
                        NumberPicker(textColor: Colors.Series, value: series)
                            .onValueChange { series = $0 }
                    )
                )

            case .rounds:
                ActivityPicker(
                    title: "Rounds",
                    color: Colors.Rounds,
                    backgroundColor: Backgrounds.RoundsBackground,
                    picker: AnyView(
                        NumberPicker(textColor: Colors.Rounds, value: rounds)
                            .onValueChange { rounds = $0 }
                    )
                )

            case .reset:
                ActivityPicker(
                    title: "Reset",
                    color: Colors.Reset,
                    backgroundColor: Backgrounds.ResetBackground,
                    picker: AnyView(
                        TimePicker(textColor: Colors.Reset, interval: reset)
                            .onValueChange { reset = $0 }
                    )
                )
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
        name = viewModel.selectedWorkOut.name
        work = viewModel.selectedWorkOut.work
        rest = viewModel.selectedWorkOut.rest
        series = viewModel.selectedWorkOut.series
        rounds = viewModel.selectedWorkOut.rounds
        reset = viewModel.selectedWorkOut.reset
    }
}
