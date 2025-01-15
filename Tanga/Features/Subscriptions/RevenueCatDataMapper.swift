//
//  RevenueCatDataMapper.swift
//  Tanga
//
//  Created by Rygel Louv on 12/01/2025.
//

import Foundation
import RevenueCat

extension Package {
    func toSubscriptionPackage() -> SubscriptionPackage {
        return SubscriptionPackage(
            id: identifier,
            productId: storeProduct.productIdentifier,
            title: getSubscriptionPackageTitle(packageType: packageType) ?? storeProduct.localizedTitle,
            type: getSubscriptionType(packageType: packageType),
            price: Price(amount: storeProduct.localizedPriceString, currency: storeProduct.currencyCode ?? "$")
        )
     }
            
    private func getSubscriptionPackageTitle(packageType: PackageType) -> String? {
        switch packageType {
        case .annual:
            return "Yearly"
        case .monthly:
            return "Monthly"
        default :
            return nil
        }
    }
    
    private func getSubscriptionType(packageType: PackageType) -> SubscriptionType {
        switch packageType {
        case .annual:
            return .yearly
        case .monthly:
            return .monthly
        default :
            fatalError("Unknown package type \(packageType)")
        }
    }
}


            
