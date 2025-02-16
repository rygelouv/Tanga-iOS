//
//  SubscriptionsViewModelTests.swift
//  TangaTests
//
//  Created by Rygel Louv on 16/02/2025.
//

import Testing
import Foundation
@testable import Tanga

class MockRevenueCatService: RevenueCatServiceProtocol {
    var mockSubscriptions: [SubscriptionPackage] = []
    var mockPurchaseResult: SubscriberInfo?
    var shouldFailPurchase = false

    func login(sessionId: String) async {}

    func logout() async {}

    func getSubscriptions() async -> [SubscriptionPackage] {
        return mockSubscriptions
    }

    func purchase(package: SubscriptionPackage) async throws -> SubscriberInfo {
        if shouldFailPurchase { throw NSError(domain: "TestError", code: 500, userInfo: [:]) }
        return mockPurchaseResult ?? SubscriberInfo(hasActiveSubscription: true, packageId: package.id)
    }

    func observeCustomerInfo(onSubscriberInfoChanged: (SubscriberInfo?) -> Void) async {}
}

@MainActor
struct SubscriptionsViewModelTests {

    @Test func testGetSubscriptions_Success() async throws {
        // Arrange: Set up mock subscriptions
        let mockService = MockRevenueCatService()
        let mockSubscriptions = [
            SubscriptionPackage(id: "1", productId: "prod_monthly", title: "Monthly Plan", type: .monthly, price: Price(amount: "9.99", currency: "$")),
            SubscriptionPackage(id: "2", productId: "prod_yearly", title: "Yearly Plan", type: .yearly, price: Price(amount: "99.99", currency: "$"))
        ]
        mockService.mockSubscriptions = mockSubscriptions

        let viewModel = SubscriptionsViewModel(revenueCatController: mockService)

        // Act: Fetch subscriptions
        viewModel.getSubscriptions()

        // Wait for async task to complete
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5s

        // Assert: Ensure subscriptions are reversed (yearly first)
        #expect(viewModel.subscriptions?.first?.type == .yearly)
        #expect(viewModel.subscriptions?.last?.type == .monthly)
    }

    @Test func testGetSubscriptions_Empty() async throws {
        // Arrange: No subscriptions
        let mockService = MockRevenueCatService()
        mockService.mockSubscriptions = []

        let viewModel = SubscriptionsViewModel(revenueCatController: mockService)

        // Act: Fetch subscriptions
        viewModel.getSubscriptions()

        try await Task.sleep(nanoseconds: 500_000_000) // 0.5s

        // Assert: Subscriptions should be nil
        #expect(viewModel.subscriptions == nil)
    }

    @Test func testOnMakePurchase_Success() async throws {
        // Arrange: Set up a valid subscription purchase
        let mockService = MockRevenueCatService()
        let package = SubscriptionPackage(id: "1", productId: "prod_monthly", title: "Monthly Plan", type: .monthly, price: Price(amount: "9.99", currency: "$"))
        mockService.mockPurchaseResult = SubscriberInfo(hasActiveSubscription: true, packageId: package.id)

        let viewModel = SubscriptionsViewModel(revenueCatController: mockService)

        // Act: Simulate a purchase
        viewModel.onMakePurchase(subscriptionPackage: package)

        try await Task.sleep(nanoseconds: 500_000_000) // 0.5s

        // Assert: Purchase updates UI states correctly
        #expect(viewModel.selectedPackage == nil)
        #expect(viewModel.closeSubscriptionScreen == true)
    }

    @Test func testGetSubscriptionCadence() {
        let mockService = MockRevenueCatService()
        let viewModel = SubscriptionsViewModel(revenueCatController: mockService)

        let monthlyPackage = SubscriptionPackage(id: "1", productId: "prod_monthly", title: "Monthly Plan", type: .monthly, price: Price(amount: "9.99", currency: "$"))
        let yearlyPackage = SubscriptionPackage(id: "2", productId: "prod_yearly", title: "Yearly Plan", type: .yearly, price: Price(amount: "99.99", currency: "$"))

        // Assert: Correctly determines cadence
        #expect(viewModel.getSubscriptionCadence(subscriptionPackage: monthlyPackage) == "Month")
        #expect(viewModel.getSubscriptionCadence(subscriptionPackage: yearlyPackage) == "Year")
    }
}
