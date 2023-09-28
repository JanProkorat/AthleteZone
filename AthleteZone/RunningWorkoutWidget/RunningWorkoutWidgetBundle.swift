//
//  RunningWorkoutWidgetBundle.swift
//  RunningWorkoutWidget
//
//  Created by Jan Prokorát on 05.08.2023.
//

import SwiftUI
import WidgetKit

@main
struct RunningWorkoutWidgetBundle: WidgetBundle {
    var body: some Widget {
        RunningWorkoutWidget()
        RunningWorkoutWidgetLiveActivity()
    }
}
