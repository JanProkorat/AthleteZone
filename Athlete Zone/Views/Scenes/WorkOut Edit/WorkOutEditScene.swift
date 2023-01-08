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

    @State var activeSheetType: ActivityType?

    @State var name = ""
    @State var work = 0
    @State var rest = 0
    @State var series = 0
    @State var rounds = 0
    @State var reset = 0
    @Binding var isEditing: Bool

    init(_ name: String, _ work: Int, _ rest: Int, _ series: Int, _ rounds: Int, _ reset: Int, _ isEditing: Binding<Bool>) {
        self._name = State(initialValue: name)
        self._work = State(initialValue: work)
        self._rest = State(initialValue: rest)
        self._series = State(initialValue: series)
        self._rounds = State(initialValue: rounds)
        self._reset = State(initialValue: reset)
        _isEditing = isEditing
    }

    var body: some View {
        BaseView(
            header: {
                WorkOutEditHeader(isEditing: isEditing)
            },
            content: {
                WorkOutEditContent(name, work, rest, series, rounds, reset)
                    .onNameChange { name = $0 }
                    .onEditFieldTab { activeSheetType = $0 }
            },
            footer: {
                WorkOutEditFooter()
                    .onCloseTab { performAction(self.onCloseTab) }
                    .onSaveTab {
                        performAction(self.onSaveTab, value: WorkOut(name, work, rest, series, rounds, reset))
                    }
            }
        )
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

struct ExerciseEditScene_Previews: PreviewProvider {
    static var previews: some View {
        WorkOutEditScene("title", 40, 60, 2, 8, 120, .constant(true))
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
