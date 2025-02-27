//
//  AmplitudeAnalyticsProvider.swift
//  Tanga
//
//  Created by Rygel Louv on 25/02/2025.
//

import Foundation
import AmplitudeSwift

class AmplitudeAnalyticsProvider: AnalyticsProvider {
    private let amplitude: Amplitude
    
    init(apiKey: String) {
        // Initialize the Amplitude SDK
        let configuration = Configuration(
            apiKey: apiKey,
            logLevel: LogLevelEnum.DEBUG,
            autocapture: [
                AutocaptureOptions.screenViews,
                AutocaptureOptions.sessions,
                AutocaptureOptions.appLifecycles
            ]
        )
        
        self.amplitude = Amplitude(configuration: configuration)
    }
    
    /**
     Tracks an analytics event, with special handling for subscription purchase events.
    */
    func track(event: AnalyticsEvent) {
        // Convert to Amplitude event properties
        let eventProperties = convertToAmplitudeProperties(event.properties)
        
        // Check if this is a subscription purchase and track revenue if it is
        if event.isSubscriptionPurchaseEvent, let details = event.subscriptionDetails {
            trackRevenue(type: details.type, price: details.price, currency: details.currency)
        }
        
        // Create and log Amplitude event
        let amplitudeEvent = BaseEvent(
            eventType: event.name,
            eventProperties: eventProperties
        )
        
        amplitude.track(event: amplitudeEvent)
    }
    
    func trackPage(page: AnalyticsPage) {
        // Convert to Amplitude event properties
        let pageProperties = convertToAmplitudeProperties(page.properties)
        
        // Add page name to properties
        var amplitudeProperties = pageProperties
        amplitudeProperties[AnalyticsConstants.Amplitude.screenName] = page.name
        
        // Create and log Amplitude page view event
        let amplitudeEvent = BaseEvent(
            eventType: AnalyticsConstants.Amplitude.screenViewed,
            eventProperties: amplitudeProperties
        )
        
        amplitude.track(event: amplitudeEvent)
    }
    
    func setUserDetails(userId: String) {
        amplitude.setUserId(userId: userId)
    }
    
    func clearUserDetails() {
        amplitude.setUserId(userId: nil)
    }
    
    /// Set user properties in Amplitude
    func setUserProperties(_ properties: AnalyticsProperties) {
        properties.forEach { setUserProperty(key: $0.key, value: $0.value) }
    }
    
    /// Set a single user property
    private func setUserProperty(key: AnalyticsPropertyKey, value: AnalyticsPropertyValue) {
        let identify = Identify()
        identify.append(property: key.name, value: value.value)
        amplitude.identify(identify: identify)
    }
    
    /**
     Tracks a revenue event for a subscription purchase.
     
     - Parameters:
        - type: The subscription type (e.g., "monthly", "yearly")
        - price: The subscription price
        - currency: The currency code (e.g., "USD")
     */
    private func trackRevenue(type: String, price: Double, currency: String) {
        let revenue = Revenue()
        revenue.productId = type
        revenue.price = price
        revenue.quantity = 1
        revenue.revenueType = AnalyticsConstants.Amplitude.subscriptionType
        
        amplitude.revenue(revenue: revenue)
    }
    
    // MARK: - Helper Methods
    
    /**
     Converts analytics properties to Amplitude format.
     
     - Parameter properties: The analytics properties to convert
     - Returns: A dictionary of properties in Amplitude format
    */
    private func convertToAmplitudeProperties(_ properties: [AnalyticsPropertyKey: AnalyticsPropertyValue]) -> [String: Any] {
        return properties.reduce(into: [String: Any]()) { result, item in
            // Use the property key name as is (no mapping needed for Amplitude)
            result[item.key.name] = item.value.value
        }
    }
    
    /// Flush events immediately
    func flushEvents() {
        amplitude.flush()
    }
}

extension AnalyticsEvent {
    /**
     Checks if this event is a subscription purchase event.
     
     - Returns: True if the event is a subscription purchase, false otherwise
     */
    var isSubscriptionPurchaseEvent: Bool {
        if let eventsEnum = self as? Events,
           case .actionSubscriptionPurchased(_, _, _) = eventsEnum {
            return true
        }
        return false
    }
    
    /**
     Extracts subscription details from a subscription purchase event.
     
     - Returns: A tuple containing subscription type, price, and currency, or nil if this is not a subscription event
     */
    var subscriptionDetails: (type: String, price: Double, currency: String)? {
        if let eventsEnum = self as? Events,
           case .actionSubscriptionPurchased(let type, let price, let currency) = eventsEnum {
            return (type, price, currency)
        }
        return nil
    }
}
