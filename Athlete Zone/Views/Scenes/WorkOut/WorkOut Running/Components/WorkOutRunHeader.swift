//
//  ExerciseRunHeaderBar.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 07.11.2022.
//

import SwiftUI

struct WorkOutRunHeader: View {
    let title: String

    var body: some View {
        TitleText(text: title, alignment: .center)
    }
}

struct ExerciseRunHeaderBar_Previews: PreviewProvider {
    static var previews: some View {
        WorkOutRunHeader(title: "Exercise name")
    }
}
