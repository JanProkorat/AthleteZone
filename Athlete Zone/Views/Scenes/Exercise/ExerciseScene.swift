//
//  ContentView.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 03.11.2022.
//

import SwiftUI

struct ExerciseScene: View {
        

    var body: some View {
        SceneView(
            header: AnyView(ExerciseHeaderBar()),
            content: AnyView(ExerciseContent()),
            isFooterVisible: true)
    }
}

struct ExerciseScene_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseScene()
            .environmentObject(WorkOutViewModel())
            .environmentObject(ViewRouter())
    }
}
