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
        TitleText(text: "\(!isEditing ? "Add" : "Edit") workout", alignment: .center)
    }
}

struct ExerciseEditHeader_Previews: PreviewProvider {
    static var previews: some View {
        WorkOutEditHeader(isEditing: false)
    }
}
