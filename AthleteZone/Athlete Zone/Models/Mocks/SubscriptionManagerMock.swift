//
//  SubscriptionManagerMock.swift
//  Athlete Zone Tests
//
//  Created by Jan Prokorát on 13.04.2024.
//

import Foundation
import StoreKit

class SubscriptionManagerMock: SubscriptionProtocol {
    var subscriptionActivated = false
    var isSubscriptionViewVisible = false

    func process(transaction verificationResult: VerificationResult<Transaction>) async {
        subscriptionActivated = true
    }

    func checkForUnfinishedTransactions() async {}

    func observeTransactionUpdates() async {}
}
