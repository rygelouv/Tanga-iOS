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
    
    private var revenueCatController: RevenueCatController
    

    init(revenueCatController: RevenueCatController) {
        self.revenueCatController = revenueCatController
    }
    
    func getSubscriptions() {
        Task {
            let subscriptionPackages = await revenueCatController.getSubscriptions()
            if !subscriptionPackages.isEmpty {
                DispatchQueue.main.async {
                    // Montly is comming first, we reverse the array to make yearl appear first
                    self.subscriptions = subscriptionPackages.reversed()
                }
            } else {
                // TODO show error
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
