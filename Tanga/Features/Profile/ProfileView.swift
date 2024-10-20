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
            
            Button(action: {
                print("Sign out Button tapped")
                Task {
                    do {
                        try await authManager.signOut()
                    } catch {
                        print("Error signing out: \(error)")
                    }
                }
            }) {
                Text("Sign out")
                    .frame(
                        maxWidth: .infinity,
                        minHeight: 36
                    )
                    .font(Font.custom("Montserrat", size: 16, relativeTo: .headline))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.cerulean)
                    .cornerRadius(16)
            }.padding()
        }.onAppear {
            viewModel.loadProfileData()
        }
    }
}

#Preview {
    ProfileView()
}
