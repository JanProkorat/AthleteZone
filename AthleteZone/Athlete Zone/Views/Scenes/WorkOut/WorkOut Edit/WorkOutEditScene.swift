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
                .padding(.top)

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
            IntervalPicker(type: $activeSheetType, interval: getInterval(activitySheet))
                .presentationDetents([.fraction(0.5)])
        }
    }

    private func getInterval(_ type: ActivityType) -> Binding<Int> {
        switch type {
        case .work:
            return $viewModel.work

        case .rest:
            return $viewModel.rest

        case .series:
            return $viewModel.series

        case .rounds:
            return $viewModel.rounds

        case .reset:
            return $viewModel.reset
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
