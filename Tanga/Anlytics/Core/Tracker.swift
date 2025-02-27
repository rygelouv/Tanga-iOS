//
//  Tracker.swift
//  Tanga
//
//  Created by Rygel Louv on 24/02/2025.
//

import Foundation

// AnalyticsTracker - Main facade for analytics tracking
/*protocol AnalyticsTracker {
    static var shared: AnalyticsTrackerImpl { get set }
    
    func track(event: AnalyticsEvent)
    func trackPage(page: AnalyticsPage)
    func setUserDetails(userId: String)
    func clearUserDetails()
    
    func setUserSubscription(
            isSubscribed: Bool,
            tier: String
    )
}*/

// Implementation of AnalyticsTracker
class AnalyticsTracker {
    
    static var shared: AnalyticsTracker = {
        let defaultProviders: [AnalyticsProvider] = [] // Initialize with real providers
        return AnalyticsTracker(providers: defaultProviders)
    }()
    
    private let providers: [AnalyticsProvider]
    
    init(providers: [AnalyticsProvider]) {
        self.providers = providers
    }
    
    func track(event: AnalyticsEvent) {
        providers.forEach { $0.track(event: event) }
    }
    
    func trackPage(page: AnalyticsPage) {
        providers.forEach { $0.trackPage(page: page) }
    }
    
    func setUserDetails(userId: String) {
        providers.forEach { $0.setUserDetails(userId: userId) }
    }
    
    func clearUserDetails() {
        providers.forEach { $0.clearUserDetails() }
    }
    
    func setUserSubscription(isSubscribed: Bool, tier: String) {
        // Build the properties using our type-safe system
        let isSubcribedProperty = Properties.isSubscribed
        let subscriptionTypeProperty = Properties.subscriptionType
        let properties: AnalyticsProperties = [
            isSubcribedProperty.key: isSubcribedProperty.boolValue(isSubscribed),
            subscriptionTypeProperty.key: subscriptionTypeProperty.stringValue(tier)
        ]
        
        // Set properties in each provider using the type-safe interface
        providers.forEach { $0.setUserProperties(properties) }
    }
}
