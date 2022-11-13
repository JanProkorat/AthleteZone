//
//  LibraryHeader.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 07.11.2022.
//

import SwiftUI

struct LibraryHeaderBar: View {
    var body: some View {
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
            
            Text("Library")
                .font(.custom("Lato-Black", size: 40))
                .bold()
                .foregroundColor(Color(Colors.MainText))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct LibraryHeaderBar_Previews: PreviewProvider {
    static var previews: some View {
        LibraryHeaderBar()
    }
}
