//
//  StoreKitManager.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 13.12.2023.
//

import Foundation
import StoreKit

@MainActor final class Store: ObservableObject {
    @Published private(set) var products: [Product] = []

    init() {}

    func fetchProducts() async {
        do {
            products = try await Product.products(
                for: [
                    "123456789", "987654321"
                ]
            )
        } catch {
            products = []
        }
    }

//    func CheckSubscriptionStatus(){
//        do {
//            let customerInfo = try await Purchases.shared.customerInfo()
//        } catch {
//            // handle error
//        }
//    }
}
