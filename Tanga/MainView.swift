//
//  File.swift
//  Tanga
//
//  Created by Rygel Louv on 28/09/2024.
//

import SwiftUI
import FirebaseStorage

enum NavigationDestinations: String, CaseIterable, Hashable {
    case Landing
    
    case Onboarding
    
    case Auth
    
    case Notifications
}

struct MainView: View {
    @State private var path = NavigationPath()
    @AppStorage("onboarding_completed") var isOnboardingCompleted: Bool = false
    
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var audioPlayerViewModel: AudioPlayerViewModel
    
    var body: some View {
        ZStack {
            NavigationStack(path: $path) {
                if isOnboardingCompleted {
                    if authManager.authState != .signedOut {
                        ContentView(navigationPath: $path).navigationDestination(for: NavigationDestinations.self) { destination in
                            NavigationDestinationView(navigationPath: $path, destination: destination)
                        }
                    } else {
                        AuthView()
                    }
                } else {
                    LandingView(path: $path).navigationDestination(for: NavigationDestinations.self) { destination in
                        NavigationDestinationView(navigationPath: $path, destination: destination)
                    }
                }
            }
            
            // Mini Player Overlay
            if audioPlayerViewModel.showMiniPlayer {
                VStack {
                    Spacer()
                    MiniPlayerView()
                        .environmentObject(audioPlayerViewModel)
                        .transition(.move(edge: .bottom))
                        .animation(.easeInOut, value: audioPlayerViewModel.showMiniPlayer)
                }
                .padding(.bottom, 50) // Avoid overlapping with bottom tabs or safe area
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
            case .Notifications:
                NotificationView()
            }
        }
    }
}
