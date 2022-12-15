//
//  ExerciseEditHeader.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 15.11.2022.
//

import SwiftUI

struct WorkOutEditHeader: View {
    var isEditing = false

    var body: some View {
        Text("\(!isEditing ? "Add" : "Edit") Exercise")
            .font(.custom("Lato-Black", size: 40))
            .bold()
            .foregroundColor(Color(Colors.MainText))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.leading, .trailing])
    }
}

struct ExerciseEditHeader_Previews: PreviewProvider {
    static var previews: some View {
        WorkOutEditHeader(isEditing: false)
    }
}
