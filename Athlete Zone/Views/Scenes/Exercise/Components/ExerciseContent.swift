//
//  ExerciseContent.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 07.11.2022.
//

import SwiftUI

struct ExerciseContent: View {
    
    @State var activeSheet: Sheet?
    @StateObject var workout: WorkOut
    @State var tmp: Int = 5
    
    var onStartTab: (() -> Void)?
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 5){
            Text("\(tmp)")
            ActivityButton(innerComponent: ActivityView(image: Icons.Play, color: Colors.Work, activity: "Work", interval: workout.work, type: .time)){
                self.tmp = workout.work
            }
                .onTab{ activeSheet = .work }
                .padding(.top, 5)
            
            ActivityButton(innerComponent: ActivityView(image: Icons.Pause, color: Colors.Rest, activity: "Rest", interval: workout.rest, type: .time))
                .onTab{ activeSheet = .rest }
            
            ActivityButton(innerComponent: ActivityView(image: Icons.Forward, color: Colors.Series, activity: "Series", interval: workout.series, type: .number))
                .onTab{ activeSheet = .series }
            
            ActivityButton(innerComponent: ActivityView(image: Icons.Repeat, color: Colors.Rounds, activity: "Rounds", interval: workout.rounds, type: .number))
                .onTab{ activeSheet = .rounds }
            
            ActivityButton(innerComponent: ActivityView(image: Icons.Time, color: Colors.Reset, activity: "ResetTime", interval: workout.reset, type: .time))
                .onTab{ activeSheet = .reset }
            
            GeometryReader { geometry in
                VStack(alignment: .center, spacing: 5) {
                    HStack(alignment: .center){
                            Text(getFormatWorkoutTime(interval: workout.timeOverview))
                                .scaledToFill()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .font(.custom("Lato-Black", size: geometry.size.height*0.25))
                        
                    }
                    .frame(maxWidth: .infinity, maxHeight: geometry.size.height * 0.5)
                    IconButton(id: "startWorkout", image: Icons.Start, color: Colors.Action, width: geometry.size.height * 0.5, height: geometry.size.height * 0.5)
                        .onTab{
                            if self.onStartTab != nil {
                                self.onStartTab!()
                            }
                        }
                        .padding(.bottom)
                    
                }
            }
        }
        .sheet(item: $activeSheet ){ $0.modalView }
    }
}

struct ExerciseContent_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseContent(workout: WorkOut())
    }
}

extension ExerciseContent{
    func onStartTab(_ handler: @escaping () -> Void) -> ExerciseContent {
        var new = self
        new.onStartTab = handler
        return new
    }
    
    func getFormatWorkoutTime(interval: Int) -> String {
        let formatter = DateComponentsFormatter()
        formatter.zeroFormattingBehavior = .pad
        formatter.allowedUnits = [.minute, .second]
        if interval >= 3600 {
            formatter.allowedUnits.insert(.hour)
        }
        return formatter.string(from: TimeInterval(interval))!
    }
}
