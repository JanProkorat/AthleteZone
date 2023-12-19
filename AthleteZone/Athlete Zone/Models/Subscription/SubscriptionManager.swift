//
//  SubscriptionManager.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 16.12.2023.
//

import Foundation
import OSLog
import StoreKit

class SubscriptionManager: ObservableObject {
    static var shared = SubscriptionManager()

    @Published var subscriptionActivated = false
    @Published var isSubscriptionViewVisible = false

    private let logger = Logger(
        subsystem: "Meet SubscriptionView",
        category: "Product Subscription"
    )

    func process(transaction verificationResult: VerificationResult<Transaction>) async {
        do {
            let unsafeTransaction = verificationResult.unsafePayloadValue
            logger.log("""
            Processing transaction ID \(unsafeTransaction.id) for \
            \(unsafeTransaction.productID)
            """)
        }

        let transaction: Transaction
        switch verificationResult {
        case .verified(let t):
            logger.debug("""
            Transaction ID \(t.id) for \(t.productID) is verified
            """)
            transaction = t
        case .unverified(let t, let error):
            // Log failure and ignore unverified transactions
            logger.error("""
            Transaction ID \(t.id) for \(t.productID) is unverified: \(error)
            """)
            return
        }

        await transaction.finish()
    }

    func checkForUnfinishedTransactions() async {
        for await transaction in Transaction.unfinished {
            Task.detached(priority: .background) {
                await self.process(transaction: transaction)
            }
        }
    }

    func observeTransactionUpdates() async {
        for await update in Transaction.updates {
            await process(transaction: update)
        }
    }
}
