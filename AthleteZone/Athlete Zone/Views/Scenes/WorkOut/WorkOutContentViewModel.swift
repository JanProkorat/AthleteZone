//
//  WorkOutContentViewModel.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 17.07.2023.
//

import Combine
import Foundation

class WorkOutContentViewModel: ObservableObject {
    @Published var router: any ViewRoutingProtocol {
        didSet { setupCurrentTabWatcher() }
    }

    @Published var currentTab: Tab = .home

    private var cancellable: AnyCancellable?

    init() {
        self.router = ViewRouter.shared

        setupCurrentTabWatcher()
    }

    private func setupCurrentTabWatcher() {
        cancellable?.cancel()

        cancellable = router.currentTabPublisher
            .sink { self.currentTab = $0 }
    }
}
