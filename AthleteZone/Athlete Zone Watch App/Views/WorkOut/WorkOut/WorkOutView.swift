//
//  WorkoutView.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 25.11.2023.
//

import SwiftUI

struct WorkOutView: View {
    @StateObject var viewModel = WorkOutViewModel()

    var body: some View {
        BaseView {
            ZStack {
                if viewModel.number > 0 {
                    FlowStepsView(flowNumber: $viewModel.number, work: $viewModel.work, rest: $viewModel.rest,
                                  series: $viewModel.series, rounds: $viewModel.rounds, reset: $viewModel.reset)
                        .onStartTap {
                            viewModel.setupRunViewModel()
                        }
                }
                if viewModel.number == 0 {
                    CustomWorkoutInitView(number: $viewModel.number)
                }
            }
        }
        .fullScreenCover(isPresented: $viewModel.isRunViewVisible, content: {
            WorkOutRunView()
                .environmentObject(viewModel.runViewModel)
                .navigationBarHidden(true)
        })
    }
}

#Preview {
    WorkOutView()
}
