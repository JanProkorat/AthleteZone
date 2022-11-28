//
//  ExerciseEditScene.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 15.11.2022.
//

import SwiftUI

struct ExerciseEditScene: View {
    
    @EnvironmentObject var viewModel: WorkOutViewModel
    @EnvironmentObject var router: ViewRouter
    
    var onCloseTab: (() -> Void)?

    var body: some View {
        SceneView(
            header: AnyView(ExerciseEditBar(isEditing: self.viewModel.workOutToEdit._id != nil)),
            content: AnyView(ExerciseEditContent().onCloseTab {
                if self.onCloseTab != nil {
                    self.onCloseTab!()
                }
            }),
            isFooterVisible: false)
        .sheet(item: $router.activeEditSheet) { activitySheet in
            switch activitySheet{
            case .work:
                ActivityPicker(title: "Work", color: Colors.Work, backgroundColor: Backgrounds.WorkBackground, picker: AnyView(TimePicker(textColor: Colors.Work, interval: self.viewModel.workOutToEdit.work).onValueChange{value in
                    self.viewModel.workOutToEdit.setWork(value)}))
            case .rest:
                ActivityPicker(title: "Rest", color: Colors.Rest, backgroundColor: Backgrounds.RestBackground, picker: AnyView(TimePicker(textColor: Colors.Rest, interval: self.viewModel.workOutToEdit.rest).onValueChange{value in
                    self.viewModel.workOutToEdit.setRest(value)}))
            case .series:
                ActivityPicker(title: "Series", color: Colors.Series, backgroundColor: Backgrounds.SeriesBackground, picker: AnyView(NumberPicker(textColor: Colors.Series, value: self.viewModel.workOutToEdit.series).onValueChange{value in
                    self.viewModel.workOutToEdit.setSeries(value)}))
            case .rounds:
                ActivityPicker(title: "Rounds", color: Colors.Rounds, backgroundColor: Backgrounds.RoundsBackground, picker: AnyView(NumberPicker(textColor: Colors.Rounds, value: self.viewModel.workOutToEdit.rounds).onValueChange{value in
                    self.viewModel.workOutToEdit.setRounds(value)}))
            case .reset:
                ActivityPicker(title: "Reset", color: Colors.Reset, backgroundColor: Backgrounds.ResetBackground, picker: AnyView(TimePicker(textColor: Colors.Reset, interval: self.viewModel.workOutToEdit.reset).onValueChange{value in
                    self.viewModel.workOutToEdit.setReset(value)}))
            }
        }
    }
}

struct ExerciseEditScene_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseEditScene()
            .environmentObject(WorkOutViewModel())
            .environmentObject(ViewRouter())

    }
}

extension ExerciseEditScene {
    func onCloseTab(_ handler: @escaping () -> Void) -> ExerciseEditScene {
        var new = self
        new.onCloseTab = handler
        return new
    }
}
