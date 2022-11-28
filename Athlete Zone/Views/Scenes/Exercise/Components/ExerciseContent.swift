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

    
    var body: some View {
        VStack(alignment: .center, spacing: 5){
            ActivityButton(innerComponent: ActivityView(image: Icons.Play, color: Colors.Work, activity: "Work", interval: viewModel.selectedWorkOut.work, type: .time))
                .onTab{ router.setActiveHomeSheet(.work) }
                .padding(.top, 5)
            
            ActivityButton(innerComponent: ActivityView(image: Icons.Pause, color: Colors.Rest, activity: "Rest", interval: viewModel.selectedWorkOut.rest, type: .time))
                .onTab{ router.setActiveHomeSheet(.rest) }
            
            ActivityButton(innerComponent: ActivityView(image: Icons.Forward, color: Colors.Series, activity: "Series", interval: viewModel.selectedWorkOut.series, type: .number))
                .onTab{ router.setActiveHomeSheet(.series) }
            
            ActivityButton(innerComponent: ActivityView(image: Icons.Repeat, color: Colors.Rounds, activity: "Rounds", interval: viewModel.selectedWorkOut.rounds, type: .number))
                .onTab{ router.setActiveHomeSheet(.rounds) }
            
            ActivityButton(innerComponent: ActivityView(image: Icons.Time, color: Colors.Reset, activity: "ResetTime", interval: viewModel.selectedWorkOut.reset, type: .time))
                .onTab{ router.setActiveHomeSheet(.reset) }
            
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
    }
}

struct ExerciseContent_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseContent()
            .environmentObject(WorkOutViewModel())
            .environmentObject(ViewRouter())
    }
}
