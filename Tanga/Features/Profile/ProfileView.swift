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
                MainCtaArea(profileStatus: profileStatus) {
                        navigationPath.append(ProfileNavigationDestinations.Subscriptions)
                }
            } else {
                ProgressView()
            }
           
            Spacer()
            RoundedCornerVStack(
                onSettingsTap: {
                    navigationPath.append(ProfileNavigationDestinations.Settings)
                    Logger.profile.info("navigation called")
                }
            )
        }.onAppear {
            viewModel.loadProfileData()
        }
    }
    
    struct MainCtaArea: View {
        let profileStatus: UserProfileStatus
        let onNavigateToSubscriptions: () -> Void
        
        var body: some View {
            HStack {
                switch profileStatus {
                case .anonymous:
                    TangaButton(
                        onButtonTap: { },
                        text: "Create an Account",
                        size: .big
                    ).padding(40)
                case .loggedIn:
                    TangaPremiumButton(onButtonTap: { onNavigateToSubscriptions() })
                        .padding(.horizontal, 40)
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

struct RoundedCornerVStack: View {
    @Environment(\.openURL) var openLink
    var onSettingsTap: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            ProfileContentAction(
                imageName: "email",
                text: "Contact Us",
                color: .yellow,
                onClick: { openLink(URL(string: "https://form.jotform.com/242065602713550")!) }
            )
            .padding(.horizontal, 30)
            .padding(.top, 40)
            .padding(.bottom, 15)
            
            ProfileContentAction(
                imageName: "insurance",
                text: "Privacy and Terms",
                color: .green,
                onClick: { Logger.profile.info("Profile tapped") }
            )
            .padding(.horizontal, 30)
            .padding(.top, 15)
            .padding(.bottom, 15)
            
            ProfileContentAction(
                imageName: "settings",
                text: "Account Settings",
                color: .blue,
                onClick: {
                    Logger.profile.info("setting tapped")
                    onSettingsTap()
                }
            )
            .padding(.horizontal, 30)
            .padding(.top, 15)
            .padding(.bottom, 20)
        }
        .background(Color.white)
               .clipShape(
                   RoundedCornerShape(corners: [.topLeft, .topRight], radius: 60)
               )
       .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
    
    struct ProfileContentAction: View {
        var imageName: String
        var text: String
        var color: Color
        var onClick: () -> Void

        var body: some View {
            Button(action: onClick) {
                HStack(spacing: 16) {
                    Image(imageName)
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(color)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 12).fill(color.opacity(0.2)))
                    
                    Text(text)
                        .font(Font.custom("Montserrat", size: 16, relativeTo: .headline))
                        .foregroundColor(.navy)
                    
                    Spacer()
                    
                    Image("right-chevron")
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundColor(.gray)
                }
                .contentShape(Rectangle()) // Ensures the entire row is clickable
            }.buttonStyle(PlainButtonStyle())
        }
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
    RoundedCornerVStack(){}
}
