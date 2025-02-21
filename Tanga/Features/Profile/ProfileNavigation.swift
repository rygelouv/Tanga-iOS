//
//  ProfileNavigation.swift
//  Tanga
//
//  Created by Rygel Louv on 08/01/2025.
//

import SwiftUI

enum ProfileNavigationDestinations: String, CaseIterable, Hashable {
    case Profile
    
    case Settings
    
    case Subscriptions
    
    case DeleteAccount
}


struct ProfileNavigationDestinationView: View {
    @Binding var navigationPath: NavigationPath
    let destination: ProfileNavigationDestinations
    
    var body: some View {
        switch destination {
        case .Profile:
            ProfileView()
        case .Settings:
            SettingsView().navigationDestination(for: ProfileNavigationDestinations.self) { destination in
                ProfileNavigationDestinationView(navigationPath: $navigationPath, destination: destination)
            }
        case .Subscriptions:
            SubscriptionsView()
        case .DeleteAccount:
            DeleteAccountView()
        }
    }
}
