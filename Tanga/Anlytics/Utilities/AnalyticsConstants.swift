//
//  AnalyticsConstants.swift
//  Tanga
//
//  Created by Rygel Louv on 24/02/2025.
//

import Foundation

// Helps avoid magic strings throughout the codebase
struct AnalyticsConstants {
    struct Subscription {
        static let monthly = "monthly"
        static let yearly = "yearly"
    }
    
    struct Amplitude {
        static let screenName = "screen_name"
        static let screenViewed = "screen_viewed"
        static let subscriptionType = "subscription"
    }
}
