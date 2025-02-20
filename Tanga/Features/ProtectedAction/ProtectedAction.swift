//
//  ProtectedAction.swift
//  Tanga
//
//  Created by Rygel Louv on 19/02/2025.
//

import Foundation

/// Represents a protected action that requires authentication or subscription
/// or both to be performed.
enum ProtectedAction {
    
    /// Actions that require a subscription to be performed
    enum SubscriptionRequiredAction {
        /// Represents the action of reading a summary
        case read(summaryId: SummaryId)
        
        /// Represents the action of listening to a summary in audio format
        case listen(summaryId: SummaryId)
        
        /// Get the summary ID associated with this action
        var summaryId: SummaryId {
            switch self {
            case .read(let id), .listen(let id):
                return id
            }
        }
    }
    
    /// Actions that require authentication to be performed
    enum AuthRequiredAction {
        /// Represents the action of saving a summary to the user's library
        case save
        
        /// Represents the action of getting a paid monthly or yearly subscription
        case subscribe
    }
    
    case subscription(SubscriptionRequiredAction)
    case auth(AuthRequiredAction)
}
