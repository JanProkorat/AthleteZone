//
//  View.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 07.12.2022.
//

import Foundation
import SwiftUI

extension View {
    func performAction(_ action: (() -> Void)?) {
        if let localAction = action {
            localAction()
        }
    }

    func performAction<T>(_ action: ((_ value: T) -> Void)?, value: T) {
        if let localAction = action {
            localAction(value)
        }
    }
}
