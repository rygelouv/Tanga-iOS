//
//  ProtectedActionInteractor.swift
//  Tanga
//
//  Created by Rygel Louv on 19/02/2025.
//

import SwiftUI
import Foundation


let weeklySummaryKey: String = "weeklySummary"

actor ProtectedActionInteractor {
    @AppStorage(weeklySummaryKey) var storedWeeklySummary: String = ""
    private let sessionManager: SessionManaging
    private let revenuecatController: RevenueCatServiceProtocol
    
    init(
        sessionManager: SessionManaging,
        revenuecatController: RevenueCatServiceProtocol
    ) {
        self.sessionManager = sessionManager
        self.revenuecatController = revenuecatController
    }
    
    /// Check if the user is allowed to perform the given action
    /// - If the user is not authenticated, `authRequired` is returned regardless of the action
    /// - If the user is authenticated and the action is a read or listen action, the user needs to
    /// have an active subscription to perform the action, otherwise `subscriptionRequired` is returned
    /// - If the user is authenticated and the action is a save action, `allowed` is returned
    /// - Parameter action: The protected action to check
    /// - Returns: The result of checking if the action is allowed
    func checkProtectedAction(_ action: ProtectedAction) async -> ProtectedActionCheckResult {
        switch action {
        case .subscription(let action):
            return await handleListenOrReadAction(action)
        case .auth:
            return await handleSaveOrSubscribeAction()
        }
    }
    
    private func handleSaveOrSubscribeAction() async -> ProtectedActionCheckResult {
        if (try? await sessionManager.hasSession()) != true { return .authRequired }
        return .allowed
    }

    
    private func handleListenOrReadAction(_ action: ProtectedAction.SubscriptionRequiredAction) async -> ProtectedActionCheckResult {
        // First check if it's a weekly summary
        if await isWeeklySummary(action.summaryId) {
            return .allowed
        }
        
        // Then check authentication
        if (try? await sessionManager.hasSession()) != true {
            return .authRequired
        }
        
        // Finally check subscription
        if !(await revenuecatController.hasActiveSubscription()) {
            return .subscriptionRequired
        }
        
        return .allowed
    }
    
    private func isWeeklySummary(_ summaryId: SummaryId) async -> Bool {
        return summaryId == storedWeeklySummary
    }
    
    func setWeeklySummary(_ summaryId: SummaryId) {
        storedWeeklySummary = summaryId
    }
}
