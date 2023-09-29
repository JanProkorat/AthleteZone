//
//  TrainingRunViewModel.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 23.04.2023.
//

import Combine
import Foundation
import SwiftUI

class TrainingRunViewModel: ObservableObject {
    @Published var trainingName: String

    #if os(iOS)
        @Published var selectedWorkFlowViewModel: PhoneWorkOutRunViewModel
    #else
        @Published var selectedWorkFlowViewModel: WatchWorkOutRunViewModel
    #endif

    @Published var closeSheet = false

    private var cancellables = Set<AnyCancellable>()

    init() {
        trainingName = ""

        #if os(iOS)
            selectedWorkFlowViewModel = PhoneWorkOutRunViewModel()
        #else
            selectedWorkFlowViewModel = WatchWorkOutRunViewModel()
        #endif

        selectedWorkFlowViewModel.$state.sink { newValue in
            if newValue == .quit {
                self.closeSheet.toggle()
            }
        }
        .store(in: &cancellables)
    }

    #if os(iOS)
        func setupViewModel(trainingName: String?, workouts: [WorkOut]) {
            closeSheet = false
            self.trainingName = trainingName ?? ""
            selectedWorkFlowViewModel.setupViewModel(workouts: workouts)
        }
    #else

        func setupViewModel(trainingName: String?, workouts: [WorkOutDto]) {
            closeSheet = false
            self.trainingName = trainingName ?? ""
            selectedWorkFlowViewModel.setupViewModel(workouts: workouts)
        }
    #endif
}
