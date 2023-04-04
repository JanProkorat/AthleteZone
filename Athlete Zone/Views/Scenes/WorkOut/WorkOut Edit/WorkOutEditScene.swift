//
//  ExerciseEditScene.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 15.11.2022.
//

import SwiftUI

struct WorkOutEditScene: View {
    var onCloseTab: ((_ newWorkoutId: String?) -> Void)?

    @State var activeSheetType: ActivityType?
    @ObservedObject var viewModel: WorkOutEditViewModel

    init(name: String, work: Int, rest: Int, series: Int, rounds: Int, reset: Int, _id: String? = nil) {
        viewModel = WorkOutEditViewModel(
            name: name,
            work: work,
            rest: rest,
            series: series,
            rounds: rounds,
            reset: reset,
            _id: _id
        )
    }

    var body: some View {
        BaseView(
            header: {
                WorkOutEditHeader()
            },
            content: {
                WorkOutEditContent()
                    .onEditFieldTab { activeSheetType = $0 }
            },
            footer: {
                WorkOutEditFooter()
                    .onCloseTab { performAction(self.onCloseTab, value: nil) }
                    .onSaveTab {
                        viewModel.save()
                        performAction(self.onCloseTab, value: viewModel._id)
                    }
            }
        )
        .environmentObject(viewModel)
        .sheet(item: $activeSheetType) { activitySheet in
            let color = ComponentColor.allCases.first(where: { activitySheet.rawValue.contains($0.rawValue) })!
            IntervalPicker(
                title: activitySheet.rawValue,
                color: color,
                backgroundColor: Background.allCases.first(where: { $0.rawValue.contains(activitySheet.rawValue) })!
            ) {
                switch activitySheet {
                case .work:
                    TimePicker(textColor: color, interval: $viewModel.work)

                case .rest:
                    TimePicker(textColor: color, interval: $viewModel.rest)

                case .series:
                    NumberPicker(textColor: color, value: $viewModel.series)

                case .rounds:
                    NumberPicker(textColor: color, value: $viewModel.rounds)

                case .reset:
                    TimePicker(textColor: color, interval: $viewModel.reset)
                }
            }
            .presentationDetents([.fraction(0.4)])
        }
    }
}

struct ExerciseEditScene_Previews: PreviewProvider {
    static var previews: some View {
        WorkOutEditScene(name: "Title", work: 30, rest: 60, series: 2, rounds: 1, reset: 120)
    }
}

extension WorkOutEditScene {
    func onCloseTab(_ handler: @escaping (_ newWorkoutId: String?) -> Void) -> WorkOutEditScene {
        var new = self
        new.onCloseTab = handler
        return new
    }
}
