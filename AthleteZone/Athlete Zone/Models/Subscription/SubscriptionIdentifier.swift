//
//  SubscriptionIdentifier.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 14.12.2023.
//

import Foundation
import SwiftUI

struct SubscriptionIdentifier {
    var group: String

    var monthly: String
    var quarterly: String
    var yearly: String
}

extension EnvironmentValues {
    private enum SubscriptionIDsKey: EnvironmentKey {
        static var defaultValue = SubscriptionIdentifier(
            group: "21426130",
            monthly: "plus.monthly",
            quarterly: "plus.quarterly",
            yearly: "plus.yearly"
        )
    }

    var passIDs: SubscriptionIdentifier {
        get { self[SubscriptionIDsKey.self] }
        set { self[SubscriptionIDsKey.self] = newValue }
    }
}
