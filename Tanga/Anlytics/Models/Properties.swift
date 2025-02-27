//
//  Properties.swift
//  Tanga
//
//  Created by Rygel Louv on 24/02/2025.
//

import Foundation

typealias AnalyticsProperties = [AnalyticsPropertyKey: AnalyticsPropertyValue]

/**
 `AnalyticsPropertyKey` is a struct that represents a key for analytics properties.
 
 This type ensures that analytics property keys are `Hashable`, making them suitable
 for use as dictionary keys. It serves as a concrete, type-safe representation of
 property names that can be used across different analytics providers.
 
 ## Purpose
 
 The main purpose of using `AnalyticsPropertyKey` instead of `String` directly is:
 
 1. Type safety - Keys are guaranteed to be correct at compile time
 2. Centralized definition - All keys are defined in one place
 3. Compatibility - Works seamlessly with different analytics providers
 4. Future-proofing - Easy to extend with additional metadata if needed
 
 ## Usage
 
 ```swift
 // Create from a predefined property
 let summaryIdKey = Properties.summaryId.key
 
 // Create a custom key
 let customKey = AnalyticsPropertyKey("custom_property")
 
 // Use as dictionary key
 let properties: [AnalyticsPropertyKey: AnalyticsPropertyValue] = [
     summaryIdKey: .string("12345"),
     customKey: .int(42)
 ]
 ```
 */
struct AnalyticsPropertyKey: Hashable {
    /**
     The property name as a string.
     
     This is the raw value that will be sent to analytics services.
    */
    let name: String
    
    /**
     Creates a key from a `Properties` enum value.
     
     - Parameter property: A value from the `Properties` enum
    */
    init(_ property: Properties) {
        self.name = property.rawValue
    }
    
    /**
     Creates a key from a custom string.
     
     This is useful for one-off properties or dynamically generated property names.
     
     - Parameter name: A string representing the property name
    */
    init(_ name: String) {
        self.name = name
    }
}

/**
 `AnalyticsPropertyValue` is an enum that represents the possible value types for analytics properties.
 
 This enum provides a type-safe way to store different value types that can be sent to analytics
 services, while maintaining the ability to convert them to the appropriate format when needed.
 
 ## Usage
 
 ```swift
 // Create different value types
 let stringValue: AnalyticsPropertyValue = .string("book_title")
 let intValue: AnalyticsPropertyValue = .int(42)
 let doubleValue: AnalyticsPropertyValue = .double(39.99)
 let boolValue: AnalyticsPropertyValue = .bool(true)
 
 // Use with properties
 let properties: [AnalyticsPropertyKey: AnalyticsPropertyValue] = [
     Properties.summaryId.key: .string("12345"),
     Properties.subscriptionPrice.key: .double(9.99)
 ]
 ```
 */
enum AnalyticsPropertyValue {
    case string(String)
    case int(Int)
    case double(Double)
    case bool(Bool)
    
    /**
     Returns the underlying value as `Any` type.
     
     This is particularly useful when converting to formats required by analytics services.
     
     - Returns: The stored value as type `Any`
    */
    var value: Any {
        switch self {
        case .string(let value): return value
        case .int(let value): return value
        case .double(let value): return value
        case .bool(let value): return value
        }
    }
}

// Enum representing type-safe property definitions
enum Properties: String {
    case summaryId = "summary_id"
    case categoryId = "category_id"
    case searchQuery = "search_query"
    case isSubscribed = "is_subscribed"
    case subscriptionType = "subscription_type"
    case subscriptionPrice = "subscription_price"
    case subscriptionCurrency = "subscription_currency"
    
    // Helper to create a key
    var key: AnalyticsPropertyKey {
        return AnalyticsPropertyKey(self)
    }
    
    // Helper method to create appropriate value type
    func stringValue(_ value: String) -> AnalyticsPropertyValue {
        switch self {
        case .summaryId, .categoryId, .searchQuery, .subscriptionType, .subscriptionCurrency:
            return .string(value)
        case .subscriptionPrice:
            if let doubleValue = Double(value) {
                return .double(doubleValue)
            } else {
                return .string(value)
            }
        default:
            return .string(value)
        }
    }
    
    func doubleValue(_ value: Double) -> AnalyticsPropertyValue {
        switch self {
        case .subscriptionPrice:
            return .double(value)
        default:
            return .string(String(value))
        }
    }
    
    func intValue(_ value: Int) -> AnalyticsPropertyValue {
        switch self {
        case .subscriptionPrice:
            return .int(value)
        default:
            return .string(String(value))
        }
    }
    
    func boolValue(_ value: Bool) -> AnalyticsPropertyValue {
        switch self {
         case .isSubscribed:
            return .bool(value)
        default:
            return .string(String(value))
        }
    }
}
