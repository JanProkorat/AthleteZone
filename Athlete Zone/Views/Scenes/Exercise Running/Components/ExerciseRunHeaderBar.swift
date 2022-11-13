//
//  ExerciseRunHeaderBar.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 07.11.2022.
//

import SwiftUI

struct ExerciseRunHeaderBar: View {
    
    let title: String
    
    var body: some View {
        Text(title)
            .font(.custom("Lato-Black", size: 40))
            .bold()
            .foregroundColor(Color(Colors.MainText))
            .frame(maxWidth: .infinity, alignment: .center)
    }
}

struct ExerciseRunHeaderBar_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseRunHeaderBar(title: "Exercise name")
    }
}
