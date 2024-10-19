//
//  File.swift
//  Tanga
//
//  Created by Rygel Louv on 28/09/2024.
//

import SwiftUI

enum NavigationDestinations: String, CaseIterable, Hashable {
    case Landing
    
    case Onboarding
    
    case Auth
    
    case Search
}


struct MainView: View {
    @State private var path = NavigationPath()
    @AppStorage("onboarding_completed") var isOnboardingCompleted: Bool = false
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        NavigationStack(path: $path) {
            if isOnboardingCompleted {
                if authManager.authState != .signedOut {
                    let _ = print("show content view")
                    ContentView(navigationPath: $path).navigationDestination(for: NavigationDestinations.self) { destination in
                        NavigationDestinationView(navigationPath: $path, destination: destination)
                    }
                } else {
                    let _ = print("show auth view")
                    AuthView()
                }
            } else {
                LandingView(path: $path).navigationDestination(for: NavigationDestinations.self) { destination in
                    NavigationDestinationView(navigationPath: $path, destination: destination)
                }
            }
        }
    }
    
    struct NavigationDestinationView: View {
        @Binding var navigationPath: NavigationPath
        let destination: NavigationDestinations
        
        var body: some View {
            switch destination {
            case .Landing:
                LandingView(path: $navigationPath)
            case .Onboarding:
                OnboardingSliderView(path: $navigationPath)
            case .Auth:
                AuthView()
            case .Search:
                SearchView()
            }
        }
    }
}
