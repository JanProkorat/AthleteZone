//
//  TrainingContentViewModel.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 18.07.2023.
//

import Combine
import Foundation

class TrainingContentViewModel: ObservableObject {
    @Published var router = ViewRouter.shared

    @Published var currentTab: Tab = .home

    private var cancellables = Set<AnyCancellable>()

    init() {
        router.$currentTab
            .sink { self.currentTab = $0 }
            .store(in: &cancellables)
    }
}
