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
        VStack {
            TitleText(text: viewModel.isEditing ?
                LocalizationKey.editWorkout.rawValue :
                LocalizationKey.addWorkout.rawValue,
                alignment: .center)
                .padding([.leading, .trailing], 10)
                .frame(maxWidth: .infinity)

            WorkOutEditContent()
                .onEditTab { activeSheetType = $0 }
                .padding([.leading, .trailing], 10)
                .padding([.top, .bottom], 5)
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            WorkOutEditFooter()
                .onCloseTab { performAction(self.onCloseTab) }
                .onSaveTab {
                    viewModel.saveWorkout()
                    performAction(self.onCloseTab)
                }
                .padding([.leading, .trailing], 10)
        }
        .background(Color(ComponentColor.darkBlue.rawValue))
        .environment(\.colorScheme, .dark)
        .ignoresSafeArea(.keyboard, edges: [.bottom])
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
