//
//  RevenueCatController.swift
//  Tanga
//
//  Created by Rygel Louv on 12/01/2025.
//

import OSLog
import Foundation
import RevenueCat

protocol RevenueCatServiceProtocol {
    func login(sessionId: String) async
    func logout() async
    func getSubscriptions() async -> [SubscriptionPackage]
    func purchase(package: SubscriptionPackage) async throws -> SubscriberInfo
    func observeCustomerInfo(onSubscriberInfoChanged: (SubscriberInfo?) -> Void) async
}

class RevenueCatController: RevenueCatServiceProtocol {
    
    // MARK: Initiliazation
    func initialize() {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "REVENUECAT_API_KEY") as? String else {return}
        Purchases.logLevel = .debug
        Purchases.configure(withAPIKey: apiKey)
    }
    
    // MARK: Login and Logout
    
    func login(sessionId: String) async {
        do {
            _ = try await Purchases.shared.logIn(sessionId)
        } catch {
            Logger.subscriptions.error("Unable to login to RevenueCat: \(error)")
        }
    }
    
    func logout() async {
        do {
            _ = try await Purchases.shared.logOut()
        } catch {
            Logger.subscriptions.error("Unable to logout from RevenueCat: \(error)")
        }
    }
    
    // MARK: Subscriptions and purchase
    
    func getSubscriptions() async -> [SubscriptionPackage] {
        do {
            let offerings = try await Purchases.shared.offerings()
            let packages = offerings.current?.availablePackages ?? []
            return packages.map { $0.toSubscriptionPackage() }
        } catch {
            Logger.subscriptions.error("Unable to get subscriptions: \(error)")
            return []
        }
    }
    
    func purchase(package: SubscriptionPackage) async throws -> SubscriberInfo {
        do {
            let offering = try await Purchases.shared.offerings()
            let package = switch package.type {
                case .monthly: offering.current?.monthly
                case .yearly: offering.current?.annual
            }
            guard let package else { fatalError("Unable to find package") }
            let purchase = try await Purchases.shared.purchase(package: package)
            Logger.subscriptions.info("Purchase complete: \(purchase.customerInfo)")
            return SubscriberInfo(hasActiveSubscription: purchase.customerInfo.activeSubscriptions.count > 0, packageId: purchase.customerInfo.activeSubscriptions.first)
        } catch {
            Logger.subscriptions.error("Unable to purchase subscription: \(error)")
            throw error
        }
    }
    
    // MARK: Customer Info
    
    func observeCustomerInfo(onSubscriberInfoChanged: (SubscriberInfo?) -> Void) async {
        for try await customerInfo in Purchases.shared.customerInfoStream {
            onSubscriberInfoChanged(SubscriberInfo(hasActiveSubscription: customerInfo.activeSubscriptions.count > 0, packageId: customerInfo.activeSubscriptions.first))
        }
    }
}
