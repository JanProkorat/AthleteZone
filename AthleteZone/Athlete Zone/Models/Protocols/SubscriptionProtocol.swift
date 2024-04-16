//
//  SubscriptionProtocol.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 13.04.2024.
//

import Foundation
import StoreKit

protocol SubscriptionProtocol: ObservableObject {
    var subscriptionActivated: Bool { get set }
    var isSubscriptionViewVisible: Bool { get set }

    func process(transaction verificationResult: VerificationResult<Transaction>) async
    func checkForUnfinishedTransactions() async
    func observeTransactionUpdates() async
}
