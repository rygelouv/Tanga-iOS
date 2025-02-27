//
//  Events.swift
//  Tanga
//
//  Created by Rygel Louv on 24/02/2025.
//

// Protocol for all analytics events
protocol AnalyticsEvent {
    var name: String { get }
    var properties: [AnalyticsPropertyKey: AnalyticsPropertyValue] { get }
}

/*
 Enum that defines all available analytics events in the app.
  
  This enum implements the `AnalyticsEvent` protocol, providing a type-safe way to track
  user interactions and other significant occurrences in the application. Each case
  represents a distinct event that can be tracked with appropriate associated values
  for required properties.
 
 Events are categorized into two main types:
 
 - **Tap Events** - User interactions with UI elements (prefixed with "tap")
 - **Action Events** - Significant actions or state changes (prefixed with "action")
 */
enum Events: AnalyticsEvent {
    // Tap events
    case tapOnboardingGetStarted
    case tapFinishOnboarding
    case tapGoogleSignIn
    case tapSkipSignIn
    case tapAuthPrivacyAndTerms
    case tapSearch
    case tapSummary(summaryId: String)
    case tapProfilePicture
    case tapWeeklySummary(summaryId: String)
    case tapSeeAllBooksInCategory(categoryId: String)
    case tapExploreSummariesFromEmptyLibrary
    case tapCategoryItemInSearch(categoryId: String)
    case tapSaveSummary(summaryId: String)
    case tapShareSummary(summaryId: String)
    case tapRemoveSavedSummary(summaryId: String)
    case tapVisualizeGraphicSummary(summaryId: String)
    case tapPlayStartAudio(summaryId: String)
    case tapReadSummary(summaryId: String)
    case tapTangaPremiumUpgrade
    case tapProfileContactUs
    case tapProfileSettings
    case tapProfilePrivacyAndTerms
    case tapProfileLogOut
    case tapProfileDeleteAccount
    case tapYearlySubscription(price: Double, currency: String)
    case tapMonthlySubscription(price: Double, currency: String)
    case tapPrivacyPolicy
    case tapTermsOfService
    
    // Action events
    case actionUserSignedIn
    case actionUserSignedOut
    case actionAccountDeleted
    case actionSummarySaved(summaryId: String)
    case actionSummaryRemoved(summaryId: String)
    case actionSearch(query: String)
    case actionSubscriptionPurchased(type: String, price: Double, currency: String)
    case actionSummaryAudioFinishedPlaying(summaryId: String) // Not tracked for now. Tracking may be complex in AudioController
    
    var name: String {
        switch self {
        // Tap events
        case .tapOnboardingGetStarted: return "ios_tap_get_started"
        case .tapFinishOnboarding: return "ios_tap_finish_onboarding"
        case .tapGoogleSignIn: return "ios_tap_google_sign_in"
        case .tapSkipSignIn: return "ios_tap_skip_sign_in"
        case .tapAuthPrivacyAndTerms: return "ios_auth_tap_privacy_and_terms"
        case .tapSearch: return "ios_tap_search"
        case .tapSummary: return "ios_tap_summary"
        case .tapProfilePicture: return "ios_tap_profile_picture"
        case .tapWeeklySummary: return "ios_tap_weekly_summary"
        case .tapSeeAllBooksInCategory: return "ios_tap_see_all_books_in_category"
        case .tapExploreSummariesFromEmptyLibrary: return "ios_tap_explore_from_empty_library"
        case .tapCategoryItemInSearch: return "ios_tap_category_item_in_search"
        case .tapSaveSummary: return "ios_tap_save_summary"
        case .tapShareSummary: return "ios_tap_share_summary"
        case .tapRemoveSavedSummary: return "ios_tap_remove_saved_summary"
        case .tapReadSummary: return "ios_tap_read_summary"
        case .tapVisualizeGraphicSummary: return "ios_tap_graphic_summary"
        case .tapPlayStartAudio: return "ios_tap_play_start_audio"
        case .tapTangaPremiumUpgrade: return "ios_tap_tanga_premium_upgrade"
        case .tapProfileContactUs: return "ios_tap_profile_contact_us"
        case .tapProfileSettings: return "ios_tap_profile_settings"
        case .tapProfilePrivacyAndTerms: return "ios_tap_profile_privacy_and_terms"
        case .tapProfileLogOut: return "ios_tap_profile_log_out"
        case .tapProfileDeleteAccount: return "ios_tap_profile_delete_account"
        case .tapYearlySubscription: return "ios_tap_yearly_subscription"
        case .tapMonthlySubscription: return "ios_tap_monthly_subscription"
        case .tapPrivacyPolicy: return "ios_tap_privacy_policy"
        case .tapTermsOfService: return "ios_tap_terms_of_service"
            
        // Action events
        case .actionUserSignedIn: return "ios_action_user_signed_in"
        case .actionUserSignedOut: return "ios_action_user_signed_out"
        case .actionAccountDeleted: return "ios_action_account_deleted"
        case .actionSummarySaved: return "ios_action_summary_saved"
        case .actionSummaryRemoved: return "ios_action_summary_removed"
        case .actionSearch: return "ios_action_search"
        case .actionSubscriptionPurchased: return "ios_action_subscription_purchased"
        case .actionSummaryAudioFinishedPlaying: return "ios_action_audio_finished_playing"
        }
    }
    
    var properties: [AnalyticsPropertyKey: AnalyticsPropertyValue] {
        switch self {
        // Properties for tap events
        case .tapSummary(let summaryId):
            return [Properties.summaryId.key: .string(summaryId)]
        case .tapWeeklySummary(let summaryId):
            return [Properties.summaryId.key: .string(summaryId)]
        case .tapSeeAllBooksInCategory(let categoryId):
            return [Properties.categoryId.key: .string(categoryId)]
        case .tapCategoryItemInSearch(let categoryId):
            return [Properties.categoryId.key: .string(categoryId)]
        case .tapSaveSummary(let summaryId):
            return [Properties.summaryId.key: .string(summaryId)]
        case .tapShareSummary(let summaryId):
            return [Properties.summaryId.key: .string(summaryId)]
        case .tapRemoveSavedSummary(let summaryId):
            return [Properties.summaryId.key: .string(summaryId)]
        case .tapReadSummary(let summaryId):
            return [Properties.summaryId.key: .string(summaryId)]
        case .tapYearlySubscription(let price, let currency):
            return [
                Properties.subscriptionType.key: .string(AnalyticsConstants.Subscription.yearly),
                Properties.subscriptionPrice.key: .double(price),
                Properties.subscriptionCurrency.key: .string(currency)
            ]
        case .tapMonthlySubscription(let price, let currency):
            return [
                Properties.subscriptionType.key: .string(AnalyticsConstants.Subscription.monthly),
                Properties.subscriptionPrice.key: .double(price),
                Properties.subscriptionCurrency.key: .string(currency)
            ]
            
        // Properties for action events
        case .actionSummarySaved(let summaryId):
            return [Properties.summaryId.key: .string(summaryId)]
        case .actionSummaryRemoved(let summaryId):
            return [Properties.summaryId.key: .string(summaryId)]
        case .actionSearch(let query):
            return [Properties.searchQuery.key: .string(query)]
        case .actionSubscriptionPurchased(let type, let price, let currency):
            return [
                Properties.subscriptionType.key: .string(type),
                Properties.subscriptionPrice.key: .double(price),
                Properties.subscriptionCurrency.key: .string(currency)
            ]
        case .actionSummaryAudioFinishedPlaying(let summaryId):
            return [Properties.summaryId.key: .string(summaryId)]
            
        // Events without properties
        default:
            return [:]
        }
    }
    
    /**
     The set of properties that are required for this event.
     
     This property helps ensure that all necessary data is provided when tracking an event.
     It's particularly useful for validation before sending events to analytics services.
     
     - Returns: A set of `AnalyticsProperty` objects that must be included with this event
    */
    var requiredProperties: Set<AnalyticsPropertyKey> {
        switch self {
        case .tapSummary, .tapWeeklySummary, .tapSaveSummary, .tapShareSummary,
             .tapRemoveSavedSummary, .actionSummarySaved, .actionSummaryRemoved,
             .tapReadSummary, .tapPlayStartAudio, .actionSummaryAudioFinishedPlaying:
            return [Properties.summaryId.key]
            
        case .tapSeeAllBooksInCategory, .tapCategoryItemInSearch:
            return [Properties.categoryId.key]
            
        case .tapYearlySubscription, .tapMonthlySubscription:
            return [Properties.subscriptionType.key, Properties.subscriptionPrice.key, Properties.subscriptionCurrency.key]
            
        case .actionSearch:
            return [Properties.searchQuery.key]
            
        case .actionSubscriptionPurchased:
            return [Properties.subscriptionType.key, Properties.subscriptionPrice.key, Properties.subscriptionCurrency.key]
            
        default:
            return []
        }
    }
}
