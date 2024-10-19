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

    var body: some View {
        VStack {
            if let user = authManager.user {
                Text("Welcome, \(user.displayName ?? "Anonymous")")
            } else {
                Text("No user signed in")
            }
            
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
            }
        }
    }
}
