//
//  AnalyitcsConfig.swift
//  Tanga
//
//  Created by Rygel Louv on 25/02/2025.
//

import SwiftUI

// Configuraiton class used to initialize the Analytics System
class AnalyitcsConfig {
    static let shared = AnalyitcsConfig()
    
    func initialize() {
        let providers: [AnalyticsProvider] = [
            FirebaseAnalyticsProvider(),
            AmplitudeAnalyticsProvider(apiKey: getAmplitudeApiKey())
        ]
        
        AnalyticsTracker.shared = AnalyticsTracker(providers: providers)
    }
    
    private func getAmplitudeApiKey() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "AMPLITURE_API_KEY") as? String ?? ""
    }
}
