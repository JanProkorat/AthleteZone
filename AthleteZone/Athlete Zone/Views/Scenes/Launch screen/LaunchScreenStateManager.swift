//
//  LaunchScreenStateManager.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 08.01.2023.
//

import Foundation

class LaunchScreenStateManager: ObservableObject {
    @Published private(set) var state: LaunchScreenStep = .firstStep

    func dismiss() {
        DispatchQueue.main.async {
            Task {
                self.state = .secondStep
                try? await Task.sleep(for: Duration.seconds(1))
                self.state = .finished
            }
        }
    }
}
