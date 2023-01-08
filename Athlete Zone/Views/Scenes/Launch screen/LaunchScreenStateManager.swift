//
//  LaunchScreenStateManager.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 08.01.2023.
//

import Foundation

final class LaunchScreenStateManager: ObservableObject { @MainActor
    @Published private(set) var state: LaunchScreenStep = .firstStep

    @MainActor
    func dismiss() {
        Task {
            state = .secondStep
            try? await Task.sleep(for: Duration.seconds(1))
            self.state = .finished
        }
    }
}
