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
}


struct ProfileNavigationDestinationView: View {
    @Binding var navigationPath: NavigationPath
    let destination: ProfileNavigationDestinations
    
    var body: some View {
        switch destination {
        case .Profile:
            ProfileView()
        case .Settings:
            SettingsView()
        case .Subscriptions:
            SubscriptionsView()
        }
    }
}
