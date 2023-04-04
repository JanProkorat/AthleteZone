//
//  ExerciseEditHeader.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 15.11.2022.
//

import SwiftUI

struct WorkOutEditHeader: View {
    @EnvironmentObject var viewModel: WorkOutEditViewModel

    var body: some View {
        TitleText(text: "\(viewModel._id == nil ? "Add" : "Edit") workout", alignment: .center)
    }
}

struct ExerciseEditHeader_Previews: PreviewProvider {
    static var previews: some View {
        WorkOutEditHeader()
            .environmentObject(WorkOutEditViewModel())
    }
}
