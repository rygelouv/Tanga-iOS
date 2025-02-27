//
//  SubscriptionPackage.swift
//  Tanga
//
//  Created by Rygel Louv on 12/01/2025.
//
import Foundation

/**
 * Represents a subscription plan that a user can purchase.
 * @property id A unique identifier for the subscription plan.
 * @property productId The Store product ID of the subscription plan.
 * @title the title of the subscription package
 * @property type The type of the subscription plan (monthly or yearly).
 * @property price The price of the subscription plan.
 */
struct SubscriptionPackage: Identifiable {
    let id: String
    let productId: String
    let title: String
    let type: SubscriptionType
    let price: Price
}

struct Price {
    let amount: String
    let currency: String
}

extension Price {
    var formattedAmount: String {
        "\(currency) \(amount)"
    }
}

enum SubscriptionType {
    case monthly
    case yearly
    
    var rawValue: String {
        switch self {
        case .monthly:
            return "monthly"
        case .yearly:
            return "yearly"
        }
    }
}

struct SubscriberInfo {
    let hasActiveSubscription: Bool
    let packageId: String?
}
