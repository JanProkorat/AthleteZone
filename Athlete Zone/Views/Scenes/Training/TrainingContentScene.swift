//
//  TrainingContentScene.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 23.03.2023.
//

import SwiftUI

struct TrainingContentScene: View {
    @EnvironmentObject var router: ViewRouter
    @StateObject var trainingViewModel = TrainingViewModel()

    var body: some View {
        GeometryReader { _ in
            VStack {
                switch router.currentTab {
                case .home:
                    TrainingScene()
                        .environmentObject(trainingViewModel)

                default:
                    Text("hello world")
                }
            }
        }
    }
}

struct TrainingContentScene_Previews: PreviewProvider {
    static var previews: some View {
        TrainingContentScene()
            .environmentObject(ViewRouter())
    }
}
