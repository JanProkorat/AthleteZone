//
//  ExerciseContent.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 07.11.2022.
//

import SwiftUI

struct ExerciseContent: View {
    
    @EnvironmentObject var viewModel: WorkOutViewModel
    @EnvironmentObject var router: ViewRouter

    @State var activeSheet: ActivitySheet?
        
    var body: some View {
        VStack(alignment: .center, spacing: 5){
            ActivityButton(innerComponent: ActivityView(image: Icons.Play, color: Colors.Work, activity: "Work", interval: viewModel.selectedWorkOut.work, type: .time))
                .onTab{ activeSheet = .work }
                .padding(.top, 5)
            
            ActivityButton(innerComponent: ActivityView(image: Icons.Pause, color: Colors.Rest, activity: "Rest", interval: viewModel.selectedWorkOut.rest, type: .time))
                .onTab{ activeSheet = .rest }
            
            ActivityButton(innerComponent: ActivityView(image: Icons.Forward, color: Colors.Series, activity: "Series", interval: viewModel.selectedWorkOut.series, type: .number))
                .onTab{ activeSheet = .series }
            
            ActivityButton(innerComponent: ActivityView(image: Icons.Repeat, color: Colors.Rounds, activity: "Rounds", interval: viewModel.selectedWorkOut.rounds, type: .number))
                .onTab{ activeSheet = .rounds }
            
            ActivityButton(innerComponent: ActivityView(image: Icons.Time, color: Colors.Reset, activity: "ResetTime", interval: viewModel.selectedWorkOut.reset, type: .time))
                .onTab{ activeSheet = .reset }
            
            GeometryReader { geometry in
                VStack(alignment: .center, spacing: 5) {
                    HStack(alignment: .center){
                        Text(viewModel.selectedWorkOut.timeOverview.toFormattedTime())
                            .scaledToFill()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .font(.custom("Lato-Black", size: geometry.size.height*0.25))
                        
                    }
                    .frame(maxWidth: .infinity, maxHeight: geometry.size.height * 0.5)
                    IconButton(id: "startWorkout", image: Icons.Start, color: Colors.Action, width: geometry.size.height * 0.5, height: geometry.size.height * 0.5)
                        .onTab{
                            self.router.currentTab = .exerciseRun
                        }
                        .padding(.bottom)
                    
                }
            }
        }
        .sheet(item: $activeSheet) { activitySheet in
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

struct ExerciseContent_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseContent()
            .environmentObject(WorkOutViewModel())
    }
}
