//
//  ProfileView.swift
//  Tanga
//
//  Created by Rygel Louv on 06/10/2024.
//

import OSLog
import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @State private var path = NavigationPath()
    @EnvironmentObject var authManager: AuthManager

    var body: some View {
        NavigationStack(path: $path) {
            ProfileContentView(navigationPath: $path)
                .navigationDestination(for: ProfileNavigationDestinations.self) { destination in
                    ProfileNavigationDestinationView(navigationPath: $path, destination: destination)
                }
        }
    }
}

struct ProfileContentView: View {
    @Binding var navigationPath: NavigationPath
    @StateObject var viewModel = ProfileViewModel(revenueCatController: RevenueCatController())
    
    var body: some View {
        VStack {
            Spacer()
            ProfilePictureView(
                url: viewModel.photoUrl ?? "",
                imageType: .squircle
            )
                .frame(width: 120, height: 120)
            
            Text(viewModel.fullName ?? "Anonymous")
                .fontWeight(.bold)
                .font(Font.custom("Montserrat", size: 18, relativeTo: .title))
                .foregroundColor(.navy)
                .padding()
            
            if let profileStatus = viewModel.profileStatus {
                MainCtaArea(
                    profileStatus: profileStatus,
                    onNavigateToSubscriptions: {
                        navigationPath.append(ProfileNavigationDestinations.Subscriptions)
                    },
                    onCreatedAccount: {
                        viewModel.onCreatedAccount()
                    }
                )
            } else {
                ProgressView()
            }
           
            Spacer()
            ProfileActionContainer(profileStatus: viewModel.profileStatus ?? .anonymous)
        }.onAppear {
            viewModel.loadProfileData()
        }
        .sheet(isPresented: $viewModel.showAuth) {
            AuthView().onDisappear {
                viewModel.dismissAuth()
                viewModel.loadProfileData() // Reload data
            }
        }
    }
    
    struct MainCtaArea: View {
        let profileStatus: UserProfileStatus
        let onNavigateToSubscriptions: () -> Void
        let onCreatedAccount: () -> Void
        
        var body: some View {
            HStack {
                switch profileStatus {
                case .anonymous:
                    TangaButton(
                        onButtonTap: { onCreatedAccount() },
                        text: "Create an Account",
                        size: .big
                    ).padding(40)
                case .loggedIn:
                    TangaPremiumButton()
                        .padding(.horizontal, 40)
                        .trackTap(event: Events.tapTangaPremiumUpgrade)
                case .premium:
                    PremiumAccountTag()
                }
            }
        }
    }
    
    struct PremiumAccountTag: View {
        var body: some View {
            HStack {
                Image("crown")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 20, height: 20)
                    .foregroundColor(.orange)
                    .padding(.leading, 8)
                
                Text("Premium Account")
                    .frame(minHeight: 36)
                    .font(Font.custom("Montserrat", size: 14, relativeTo: .headline))
                    .fontWeight(.bold)
                    .foregroundColor(.orange)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
            }
            .padding(.horizontal, 10)
            .background(Color.orangeTransparent)
            .cornerRadius(100)
       }
   }
}

struct ProfileActionContainer: View {
    @Environment(\.openURL) var openLink
    let profileStatus: UserProfileStatus
    
    var body: some View {
        VStack(spacing: 0) {
            ProfileContentAction(
                imageName: "email",
                text: "Contact Us",
                color: .yellow,
                onClick: {
                    openLink(URL(string: "https://form.jotform.com/242065602713550")!)
                    AnalyticsTracker.shared.track(event: Events.tapProfileContactUs)
                }
            )
            .padding(.horizontal, 30)
            .padding(.top, 40)
            .padding(.bottom, 15)
            
           
            ProfileContentNavAction(
                destination: PrivacyAndTermsView(),
                imageName: "insurance",
                text: "Privacy and Terms",
                color: .green
            )
            .padding(.horizontal, 30)
            .padding(.top, 15)
            .padding(.bottom, 15)
            .trackTap(event: Events.tapProfilePrivacyAndTerms)

            
            if profileStatus != .anonymous {
                ProfileContentNavAction(
                    destination: SettingsView(),
                    imageName: "settings",
                    text: "Account Settings",
                    color: .blue
                )
                .padding(.horizontal, 30)
                .padding(.top, 15)
                .padding(.bottom, 20)
                .trackTap(event: Events.tapProfileSettings)
            }
        }
        .background(Color.white)
               .clipShape(
                   RoundedCornerShape(corners: [.topLeft, .topRight], radius: 60)
               )
       .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}

struct RoundedCornerShape: Shape {
    var corners: UIRectCorner
    var radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    ProfileView()
}

#Preview {
    ProfileActionContainer(profileStatus: .loggedIn)
}
