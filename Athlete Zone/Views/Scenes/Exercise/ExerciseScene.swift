//
//  ContentView.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 03.11.2022.
//

import SwiftUI

struct ExerciseScene: View {
    
    @EnvironmentObject var viewModel: WorkOutViewModel
    @EnvironmentObject var router: ViewRouter
    
    @State var isModalActive = false

    var body: some View {
        SceneView(
            header: AnyView(ExerciseHeaderBar(name: viewModel.selectedWorkOut.name).onSaveTab {
                viewModel.setWorkOutToEdit(viewModel.selectedWorkOut)
                isModalActive = true
            }),
            content: AnyView(ExerciseContent()),
            isFooterVisible: true)
        .fullScreenCover(isPresented: $isModalActive, content: {
            ExerciseEditScene().onCloseTab {
                isModalActive = false
            }
        })
        .sheet(item: $router.activeHomeSheet) { activitySheet in
            switch activitySheet{
            case .work:
                ActivityPicker(title: "Work", color: Colors.Work, backgroundColor: Backgrounds.WorkBackground, picker: AnyView(TimePicker(textColor: Colors.Work, interval: self.viewModel.selectedWorkOut.work).onValueChange{value in
                    self.viewModel.selectedWorkOut.setWork(value)}))
            case .rest:
                ActivityPicker(title: "Rest", color: Colors.Rest, backgroundColor: Backgrounds.RestBackground, picker: AnyView(TimePicker(textColor: Colors.Rest, interval: self.viewModel.selectedWorkOut.rest).onValueChange{value in
                    self.viewModel.selectedWorkOut.setRest(value)}))
            case .series:
                ActivityPicker(title: "Series", color: Colors.Series, backgroundColor: Backgrounds.SeriesBackground, picker: AnyView(NumberPicker(textColor: Colors.Series, value: self.viewModel.selectedWorkOut.series).onValueChange{value in
                    self.viewModel.selectedWorkOut.setSeries(value)}))
            case .rounds:
                ActivityPicker(title: "Rounds", color: Colors.Rounds, backgroundColor: Backgrounds.RoundsBackground, picker: AnyView(NumberPicker(textColor: Colors.Rounds, value: self.viewModel.selectedWorkOut.rounds).onValueChange{value in
                    self.viewModel.selectedWorkOut.setRounds(value)}))
            case .reset:
                ActivityPicker(title: "Reset", color: Colors.Reset, backgroundColor: Backgrounds.ResetBackground, picker: AnyView(TimePicker(textColor: Colors.Reset, interval: self.viewModel.selectedWorkOut.reset).onValueChange{value in
                    self.viewModel.selectedWorkOut.setReset(value)}))
            }
        }
    }
}

struct ExerciseScene_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseScene()
            .environmentObject(WorkOutViewModel())
            .environmentObject(ViewRouter())
    }
}
