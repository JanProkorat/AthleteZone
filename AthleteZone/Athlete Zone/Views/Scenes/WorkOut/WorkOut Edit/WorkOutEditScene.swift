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
                TitleText(text: viewModel.isEditing ?
                    LocalizationKey.editWorkout.rawValue :
                    LocalizationKey.addWorkout.rawValue,
                    alignment: .center)
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
                    .padding(.bottom)
            }
        )
        .environmentObject(viewModel)
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
