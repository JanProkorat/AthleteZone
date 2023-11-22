//
//  TrainingContentViewModel.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 18.07.2023.
//

import Combine
import Foundation

class TrainingContentViewModel: ObservableObject {
    @Published var router: any ViewRoutingProtocol {
        didSet { self.setupCurrentTabWatcher() }
    }

    @Published var currentTab: Tab = .home

    private var cancellable: AnyCancellable?

    init() {
        router = ViewRouter.shared

        setupCurrentTabWatcher()
    }

    private func setupCurrentTabWatcher() {
        cancellable?.cancel()

        cancellable = router.currentTabPublisher
            .sink { self.currentTab = $0 }
    }
}
