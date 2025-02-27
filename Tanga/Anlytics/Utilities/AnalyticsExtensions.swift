//
//  AnalyticsExtensions.swift
//  Tanga
//
//  Created by Rygel Louv on 24/02/2025.
//

import Foundation
import FirebaseAnalytics

// Extension for converting to Firebase parameters
extension Dictionary where Key == AnalyticsPropertyKey, Value == AnalyticsPropertyValue {
    func mapToFirebaseParameters() -> [String: Any] {
        return self.reduce(into: [String: Any]()) { result, item in
            // Map property keys to Firebase parameter names when possible
            let key = mapKeyToFirebaseParameter(item.key.name)
            result[key] = item.value.value
        }
    }
    
    private func mapKeyToFirebaseParameter(_ propertyName: String) -> String {
        switch propertyName {
        case "summary_id":
            return AnalyticsParameterItemID
        case "category_id":
            return AnalyticsParameterItemCategory
        case "search_query":
            return AnalyticsParameterSearchTerm
        case "subscription_price":
            return AnalyticsParameterValue
        case "subscription_currency":
            return AnalyticsParameterCurrency
        default:
            return propertyName
        }
    }
}
