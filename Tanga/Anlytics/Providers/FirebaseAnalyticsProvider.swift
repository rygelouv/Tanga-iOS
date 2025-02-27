//
//  FirebaseAnalyticsProvider.swift
//  Tanga
//
//  Created by Rygel Louv on 24/02/2025.
//

import FirebaseAnalytics

class FirebaseAnalyticsProvider: AnalyticsProvider {
    
    func track(event: AnalyticsEvent) {
        // Convert to Firebase parameters
        let parameters = event.properties.mapToFirebaseParameters()
        
        // Use Firebase standard events when possible
        let eventName = mapToFirebaseStandardEvent(event.name)
        
        // Log to Firebase
        Analytics.logEvent(eventName, parameters: parameters)
    }
    
    func trackPage(page: AnalyticsPage) {
        // Convert to Firebase parameters
        let parameters = page.properties.mapToFirebaseParameters()
        
        // Log custom screen event
        Analytics.logEvent(page.name, parameters: parameters)
        
        // Also log standard screen_view event
        var screenParameters = parameters
        screenParameters[AnalyticsParameterScreenName] = page.name
        Analytics.logEvent(AnalyticsEventScreenView, parameters: screenParameters)
    }
    
    func setUserDetails(userId: String) {
        Analytics.setUserID(userId)
    }
    
    func clearUserDetails() {
        Analytics.setUserID(nil)
    }
    
    func setUserProperties(_ properties: AnalyticsProperties) {
        for (key, value) in properties {
            // Get the string value from the property
            let propertyValue = stringFromPropertyValue(value)
            
            // Truncate if needed (Firebase has a 36 character limit)
            let truncatedValue = propertyValue.count > 36 ? String(propertyValue.prefix(36)) : propertyValue
            
            // Set in Firebase
            Analytics.setUserProperty(truncatedValue, forName: key.name)
        }
    }
    
    private func mapToFirebaseStandardEvent(_ eventName: String) -> String {
        // Map app-specific events to Firebase standard events when possible
        switch eventName {
        case "ios_action_user_signed_in":
            return AnalyticsEventLogin
        case "ios_action_search":
            return AnalyticsEventSearch
        case "ios_tap_share_summary":
            return AnalyticsEventShare
        case "ios_action_subscription_purchased":
            return AnalyticsEventPurchase
        case "ios_tap_summary":
            return AnalyticsEventSelectItem
        default:
            return eventName
        }
    }
    
    private func stringFromPropertyValue(_ value: AnalyticsPropertyValue) -> String {
        switch value {
        case .string(let stringValue):
            return stringValue
        case .int(let intValue):
            return String(intValue)
        case .double(let doubleValue):
            return String(doubleValue)
        case .bool(let boolValue):
            return boolValue ? "true" : "false"
        }
    }
}
