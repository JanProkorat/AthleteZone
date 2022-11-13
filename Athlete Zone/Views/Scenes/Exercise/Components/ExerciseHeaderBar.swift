//
//  ExerciseHeaderView.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 07.11.2022.
//

import SwiftUI

struct ExerciseHeaderBar: View {
//    @EnvironmentObject var viewModel: WorkOutViewModel
    
    var onSectionChangeTab: (() -> Void)?
    
    var body: some View {
        HStack(){
            HStack(alignment: .top, spacing: 5.0){
                Menu {
                    Button(action: {
                    }, label: {
                        Label("Trainings", systemImage: "paperplane")
                    })
                    Button(action: {
                    }, label: {
                        Label("Workouts", systemImage: "paperplane")
                    })
                }
            label: {
                Image(Icons.ArrowDown)
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Color(Colors.MainText))
            }
                
                Text("tmp")
                    .font(.custom("Lato-Black", size: 40))
                    .bold()
                    .foregroundColor(Color(Colors.MainText))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            HStack(alignment: .top, spacing: 5.0){
                IconButton(id: "save", image: Icons.Save, color: Colors.MainText, width: 50, height: 45)
                    .onTab {
                        print("save pressed")
                    }
                IconButton(id: "donate", image: Icons.Donate, color: Colors.MainText, width: 50, height: 45)
                    .onTab {
                        print("donate pressed")
                    }
            }
            .frame(alignment: .trailing)
            
        }
    }
}

struct ExerciseHeaderBar_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseHeaderBar()
    }
}

extension ExerciseHeaderBar {
    func onSectionChangeTab(action: @escaping (() -> Void)) -> ExerciseHeaderBar {
        ExerciseHeaderBar(onSectionChangeTab: action)
    }
}
