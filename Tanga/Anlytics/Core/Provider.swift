//
//  Provider.swift
//  Tanga
//
//  Created by Rygel Louv on 24/02/2025.
//

import Foundation

// AnalyticsProvider - Interface for all analytics providers
protocol AnalyticsProvider {
    func track(event: AnalyticsEvent)
    func trackPage(page: AnalyticsPage)
    func setUserDetails(userId: String)
    func clearUserDetails()
    
    /**
     Sets user properties for segmentation and analysis.
     Uses the same property system as events for consistency.
     
     - Parameter properties: Dictionary of user properties to set
     */
    func setUserProperties(_ properties: AnalyticsProperties)
}
