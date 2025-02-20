//
//  ProtectedActionCheckResult.swift
//  Tanga
//
//  Created by Rygel Louv on 19/02/2025.
//


/// Represents the result of checking if a protected action is allowed to be performed
enum ProtectedActionCheckResult {
    /// Represents the case where the user needs to authenticate to perform the action
    case authRequired
    
    /// Represents the case where the user needs to subscribe to perform the action
    case subscriptionRequired
    
    /// Represents the case where the user is allowed to perform the action
    case allowed
}
