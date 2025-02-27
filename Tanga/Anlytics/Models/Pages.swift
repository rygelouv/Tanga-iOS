//
//  Pages.swift
//  Tanga
//
//  Created by Rygel Louv on 24/02/2025.
//

import Foundation

// Protocol for all analytics pages
protocol AnalyticsPage {
    var name: String { get }
    var properties: [AnalyticsPropertyKey: AnalyticsPropertyValue] { get }
}

enum Pages: AnalyticsPage {
    case landing
    case onboarding
    case authentication
    case home
    case library
    case profile
    case summaryByCategory(categoryId: String)
    case search
    case summaryDetails(summaryId: String)
    case playSummaryAudio(summaryId: String)
    case subscription
    case readSummary(summaryId: String)
    case settings
    case privacyAndTerms
    case deleteAccount
    
    var name: String {
        switch self {
        case .landing: return "landing_screen"
        case .onboarding: return "onboarding_screen"
        case .authentication: return "authentication_screen"
        case .home: return "home_screen"
        case .library: return "library_screen"
        case .profile: return "profile_screen"
        case .summaryByCategory: return "summaries_by_category_screen"
        case .search: return "search_screen"
        case .summaryDetails: return "summary_details_screen"
        case .playSummaryAudio: return "play_summary_audio_screen"
        case .subscription: return "subscription_screen"
        case .readSummary: return "read_summary_screen"
        case .settings: return "settings_screen"
        case .privacyAndTerms: return "privacy_and_terms_screen"
        case .deleteAccount: return "delete_account_screen"
        }
    }
    
    var properties: [AnalyticsPropertyKey: AnalyticsPropertyValue] {
        switch self {
        case .summaryByCategory(let categoryId):
            return [Properties.categoryId.key: .string(categoryId)]
        case .summaryDetails(let summaryId), .playSummaryAudio(let summaryId), .readSummary(let summaryId):
            return [Properties.summaryId.key: .string(summaryId)]
        default:
            return [:]
        }
    }
}
