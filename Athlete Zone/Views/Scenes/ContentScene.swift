//
//  ContentView.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 06.11.2022.
//

import SwiftUI

struct ContentScene: View {
    
    @StateObject var router: ViewRouter
    @StateObject var workOutViewModel = WorkOutViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            VStack() {
                switch router.currentTab {
                case .home:
                    ExerciseScene()
                case .library:
                    LibraryScene()
                case .profile:
                    ProfileScene()
                case .setting:
                    SettingsScene()
                case .exerciseRun:
                    ExerciseRunScene()
                case .editExercise:
                    ExerciseEditScene()
                }
            }
            .environmentObject(router)
            .environmentObject(workOutViewModel)
        }
    }
}

struct ContentScene_Previews: PreviewProvider {
    static var previews: some View {
        ContentScene(router: ViewRouter())
            .environmentObject(WorkOutViewModel())
            .environmentObject(ViewRouter())
    }
}
