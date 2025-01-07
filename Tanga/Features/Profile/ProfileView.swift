//
//  ProfileView.swift
//  Tanga
//
//  Created by Rygel Louv on 06/10/2024.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @EnvironmentObject var authManager: AuthManager
    @StateObject var viewModel = ProfileViewModel()

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
            
           
            if viewModel.showUpgrateButton {
                TangaPremiumButton(onButtonTap: { print("Premium button tapped")})
                    .padding(.horizontal, 40)
            } else {
                TangaButton(
                    onButtonTap: { print("Big button tapped") },
                    text: "Create an Account",
                    size: .big
                ).padding(40)
                
            }
           
            Spacer()
            RoundedCornerVStack()
        }.onAppear {
            viewModel.loadProfileData()
        }
    }
}

struct RoundedCornerVStack: View {
    @Environment(\.openURL) var openLink
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
                onClick: { print("Profile tapped") }
            )
            .padding(.horizontal, 30)
            .padding(.top, 15)
            .padding(.bottom, 15)
            
            NavigationLink(destination: SettingsView()) {
                VStack {
                    ProfileContentAction(
                        imageName: "settings",
                        text: "Account Settings",
                        color: .blue,
                        onClick: { print("Profile tapped") }
                    )
                    .padding(.horizontal, 30)
                    .padding(.top, 15)
                    .padding(.bottom, 20)
                }
            }.buttonStyle(PlainButtonStyle())
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
            NavigationLink(destination: SettingsView()) {
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
            }
            .buttonStyle(PlainButtonStyle()) // Removes the default button styling
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
    RoundedCornerVStack()
}
