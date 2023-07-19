//
//  ExerciseEditScene.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 15.11.2022.
//

import SwiftUI

struct WorkOutEditScene: View {
    var onCloseTab: (() -> Void)?

    @State var activeSheetType: ActivityType?
    @EnvironmentObject var viewModel: WorkOutEditViewModel

    var body: some View {
        BaseView(
            header: {
                TitleText(text: "\(viewModel.isEditing ? "Edit" : "Add") workout", alignment: .center)
            },
            content: {
                WorkOutEditContent()
                    .onEditTab { activeSheetType = $0 }
            },
            footer: {
                WorkOutEditFooter()
                    .onCloseTab { performAction(self.onCloseTab) }
                    .onSaveTab {
                        viewModel.saveWorkout()
                        performAction(self.onCloseTab)
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
        WorkOutEditScene()
            .environmentObject(WorkOutEditViewModel())
    }
}

extension WorkOutEditScene {
    func onCloseTab(_ handler: @escaping () -> Void) -> WorkOutEditScene {
        var new = self
        new.onCloseTab = handler
        return new
    }
}
