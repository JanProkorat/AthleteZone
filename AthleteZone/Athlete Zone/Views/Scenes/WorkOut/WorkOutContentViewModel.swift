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
        didSet {
            cancellable = router.currentTabPublisher
                .sink { self.currentTab = $0 }
        }
    }

    @Published var currentTab: Tab = .home

    private var cancellable: AnyCancellable?

    init() {
        router = ViewRouter.shared
    }
}
