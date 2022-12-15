//
//  ExerciseEditScene.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 15.11.2022.
//

import SwiftUI

struct WorkOutEditScene: View {
    @EnvironmentObject var router: ViewRouter

    var onCloseTab: (() -> Void)?
    var onSaveTab: ((_ workout: WorkOut) -> Void)?

    @State var name = ""
    @State var work = 0
    @State var rest = 0
    @State var series = 0
    @State var rounds = 0
    @State var reset = 0
    var isEditing = false

    init(_ name: String, _ work: Int, _ rest: Int, _ series: Int, _ rounds: Int, _ reset: Int, _ isEditing: Bool? = nil) {
        self._name = State(initialValue: name)
        self._work = State(initialValue: work)
        self._rest = State(initialValue: rest)
        self._series = State(initialValue: series)
        self._rounds = State(initialValue: rounds)
        self._reset = State(initialValue: reset)
        self.isEditing = isEditing ?? false
    }

    var body: some View {
        SceneView(
            header: AnyView(WorkOutEditHeader(isEditing: isEditing)),
            content: AnyView(
                WorkOutEditContent(name, work, rest, series, rounds, reset)
                    .onNameChange { name = $0 }
            ),
            footer: AnyView(
                WorkOutEditFooter()
                    .onCloseTab { performAction(self.onCloseTab) }
                    .onSaveTab {
                        performAction(self.onSaveTab, value: WorkOut(name, work, rest, series, rounds, reset))
                    }
            )
        )
        .sheet(item: $router.activeEditSheet) { activitySheet in
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

struct ExerciseEditScene_Previews: PreviewProvider {
    static var previews: some View {
        WorkOutEditScene("title", 40, 60, 2, 8, 120)
            .environmentObject(WorkOutViewModel())
            .environmentObject(ViewRouter())
    }
}

extension WorkOutEditScene {
    func onCloseTab(_ handler: @escaping () -> Void) -> WorkOutEditScene {
        var new = self
        new.onCloseTab = handler
        return new
    }

    func onSaveTab(_ handler: @escaping (_ value: WorkOut) -> Void) -> WorkOutEditScene {
        var new = self
        new.onSaveTab = handler
        return new
    }
}
