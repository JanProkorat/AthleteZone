//
//  WorkOutContentViewModel.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 17.07.2023.
//

import Combine
import Foundation

class WorkOutContentViewModel: ObservableObject {
    @Published var router = ViewRouter.shared

    @Published var currentTab: Tab = .home

    private var cancellables = Set<AnyCancellable>()

    init() {
        router.$currentTab
            .sink { self.currentTab = $0 }
            .store(in: &cancellables)
    }
}
