//
//  ProtectedActionInteractorTests.swift
//  Tanga
//
//  Created by Rygel Louv on 20/02/2025.
//

import Testing
import Foundation
@testable import Tanga

class MockSessionManager: SessionManaging {
    var hasSessionResult: Bool = false
    
    func hasSession() async -> Bool {
        return hasSessionResult
    }
}

@MainActor
struct ProtectedActionInteractorTests {
    
    @Test func testCheckProtectedAction_AuthRequired() async throws {
        // Arrange: User is NOT authenticated
        let mockSessionManager = MockSessionManager()
        let mockRevenueCatService = MockRevenueCatService()
        let interactor = ProtectedActionInteractor(
            sessionManager: mockSessionManager,
            revenuecatController: mockRevenueCatService
        )
        
        // Act: Perform an auth-required action
        let action = ProtectedAction.auth(.save)
        let result = await interactor.checkProtectedAction(action)
        
        // Assert: Should require authentication
        #expect(result == .authRequired)
    }

    @Test func testCheckProtectedAction_SubscriptionRequired() async throws {
        // Arrange: User is authenticated but does NOT have a subscription
        let mockSessionManager = MockSessionManager()
        mockSessionManager.hasSessionResult = true

        let mockRevenueCatService = MockRevenueCatService()
        mockRevenueCatService.hasActiveSubscriptionResult = false
        
        let interactor = ProtectedActionInteractor(
            sessionManager: mockSessionManager,
            revenuecatController: mockRevenueCatService
        )
        
        // Act: Perform a subscription-required action
        let result = await interactor.checkProtectedAction(ProtectedAction.subscription(.read(summaryId: SummaryId("some-summary"))))
        
        // Assert: Should require subscription
        #expect(result == .subscriptionRequired)
    }

    @Test func testCheckProtectedAction_AllowedWithSubscription() async throws {
        // Arrange: User is authenticated and has a subscription
        let mockSessionManager = MockSessionManager()
        mockSessionManager.hasSessionResult = true

        let mockRevenueCatService = MockRevenueCatService()
        mockRevenueCatService.hasActiveSubscriptionResult = true
        
        let interactor = ProtectedActionInteractor(
            sessionManager: mockSessionManager,
            revenuecatController: mockRevenueCatService
        )
        
        // Act: Perform a subscription-required action
        let result = await interactor.checkProtectedAction(ProtectedAction.subscription(.listen(summaryId: SummaryId("some-summary"))))
        
        // Assert: Should be allowed
        #expect(result == .allowed)
    }

    @Test func testCheckProtectedAction_AllowedForWeeklySummary() async throws {
        // Arrange: User is NOT authenticated and checking a weekly summary
        let mockSessionManager = MockSessionManager()
        let mockRevenueCatService = MockRevenueCatService()
        
        let interactor = ProtectedActionInteractor(
            sessionManager: mockSessionManager,
            revenuecatController: mockRevenueCatService
        )

        // Ensure storedWeeklySummary is set inside an async context
        await interactor.setWeeklySummary("weekly-summary-id")

        // Act: Check a weekly summary
        let result = await interactor.checkProtectedAction(ProtectedAction.subscription(.read(summaryId: SummaryId("weekly-summary-id"))))

        // Assert: Should be allowed
        #expect(result == .allowed)
    }


    @Test func testCheckProtectedAction_AllowedForSaveAction() async throws {
        // Arrange: User is authenticated
        let mockSessionManager = MockSessionManager()
        mockSessionManager.hasSessionResult = true
        let mockRevenueCatService = MockRevenueCatService()
        
        let interactor = ProtectedActionInteractor(
            sessionManager: mockSessionManager,
            revenuecatController: mockRevenueCatService
        )
        
        // Act: Perform a save action
        let result = await interactor.checkProtectedAction(ProtectedAction.auth(.save))
        
        // Assert: Should be allowed
        #expect(result == .allowed)
    }
}
