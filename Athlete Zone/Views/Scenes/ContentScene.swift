//
//  ContentView.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 06.11.2022.
//

import SwiftUI

struct ContentScene: View {
    
    @StateObject var router: ViewRouter
//    @StateObject private var workOutViewModel = WorkOutViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            VStack() {
                switch router.currentTab {
                case .home:
                    ExerciseScene(router: router)
                case .library:
                    LibraryScene(router: router)
                case .profile:
                    ProfileScene(router: router)
                case .setting:
                    SettingsScene(router: router)
                case .exerciseRun:
                    ExerciseRunScene(router: router)
                }
            }
//            .environmentObject(workOutViewModel)
        }
    }
}

struct ContentScene_Previews: PreviewProvider {
    static var previews: some View {
        ContentScene(router: ViewRouter())
    }
}
