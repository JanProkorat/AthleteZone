//
//  ExerciseRunContent.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 07.11.2022.
//

import SwiftUI

struct ExerciseRunContent: View {
    
    @State private var isRunning = true
    
    var onQuitTab: (() -> Void)?
    
    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            DescriptionLabel(title: "Round 1/1", color: Colors.Rounds)
            DescriptionLabel(title: "Exercise 1/6", color: Colors.Series)
            Text(isRunning ? "Work" : "Rest")
                .font(.custom("Lato-Black", size: 20))
                .bold()
                .padding(.top, 10)
                .frame(maxWidth: .infinity, alignment: .center)
            
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    ZStack{
                        CircularProgressBar(color: isRunning ? Colors.Pink : Colors.Yellow, progress: 0.64)
                        CounterText(text: "00:35", size: geometry.size.height * 0.14)
                    }
                    
                    HStack(alignment: .center, spacing: 5){
                        IconButton(id: "Pause", image: isRunning ? Icons.Pause : Icons.Start, color: Colors.Action, width: geometry.size.height * 0.3, height: geometry.size.height * 0.3)
                            .onTab{
                                isRunning = !isRunning
                            }
                        IconButton(id: "Continue", image: Icons.Forward, color: Colors.Action, width: geometry.size.height * 0.27, height: geometry.size.height * 0.27)
                    }
                }
            }
            Button {
                if !isRunning {
                    if self.onQuitTab != nil{
                        self.onQuitTab!();
                    }
                }
            } label: {
                Text(isRunning ? "Previous exercise" : "Quit exercise")
                    .font(.custom("Lato-ThinItalic", size: 20))
                    .bold()
            }
            .padding(.top, 10)
            .frame(maxWidth: .infinity, alignment: .center)
            .foregroundColor(Color(Colors.MainText))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
    }
}

struct ExerciseRunContent_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseRunContent()
    }
}

extension ExerciseRunContent{
    func onQuitTab(_ handler: @escaping () -> Void) -> ExerciseRunContent {
        var new = self
        new.onQuitTab = handler
        return new
    }
}
