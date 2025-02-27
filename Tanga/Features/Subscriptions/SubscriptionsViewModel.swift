//
//  SubscriptionsViewModel.swift
//  Tanga
//
//  Created by Rygel Louv on 12/01/2025.
//
import SwiftUI

@MainActor
class SubscriptionsViewModel: ObservableObject {
    @Published var subscriptions: [SubscriptionPackage]?
    @Published var selectedPackage: SubscriptionPackage?
    @Published var closeSubscriptionScreen: Bool = false
    @Published var error: Error?
    
    private let revenueCatController: RevenueCatServiceProtocol
    
    init(revenueCatController: RevenueCatServiceProtocol) {
        self.revenueCatController = revenueCatController
    }
    
    func getSubscriptions() {
        Task {
            let subscriptionPackages = try await revenueCatController.getSubscriptions()
            if !subscriptionPackages.isEmpty {
                DispatchQueue.main.async {
                    // Montly is comming first, we reverse the array to make yearl appear first
                    self.subscriptions = subscriptionPackages.reversed()
                }
            } else {
                let error = NSError(domain: "Subscriptions", code: 0, userInfo: [NSLocalizedDescriptionKey: "unable to retrieve subscriptions"])
                TangaLogger.shared.error("unable to retrieve subscriptions: \(error.localizedDescription)")
                self.error = error
            }
        }
    }
    
    func onMakePurchase(subscriptionPackage: SubscriptionPackage) {
        self.selectedPackage = subscriptionPackage
        Task {
            let subscriberInfo = try await revenueCatController.purchase(package: subscriptionPackage)
            DispatchQueue.main.async {
                self.selectedPackage = nil
                if subscriberInfo.hasActiveSubscription {
                    self.closeSubscriptionScreen = true
                    AnalyticsTracker.shared.track(
                        event: Events.actionSubscriptionPurchased(
                            type: subscriptionPackage.type.rawValue,
                            price: Double(subscriptionPackage.price.amount) ?? 0,
                            currency: subscriptionPackage.price.currency.lowercased()
                        )
                    )
                }
            }
        }
    }
    
    func getSubscriptionCadence(subscriptionPackage: SubscriptionPackage) -> String {
        switch subscriptionPackage.type {
        case .monthly:
            return "Month"
        case .yearly:
            return "Year"
        }
    }
}
