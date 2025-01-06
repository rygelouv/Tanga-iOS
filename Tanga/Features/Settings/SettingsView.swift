//
//  SettingsView.swift
//  Tanga
//
//  Created by Rygel Louv on 06/01/2025.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authManager: AuthManager
    
    @State private var showLogoutAlert = false
    
    var body: some View {
        VStack {
            Button("Logout") {
                showLogoutAlert = true
            }
            .alert("Confirm Logout", isPresented: $showLogoutAlert) {
                Button("Yes", role: .destructive) {
                    onSignOut()
                }
                Button("No", role: .cancel) { }
            } message: {
                Text("Are you sure you want to logout?")
            }
        }
        .padding()
    }
    
    func onSignOut() {
        Task {
            do {
                try await authManager.signOut()
                dismiss()
            } catch {
                print("Error signing out: \(error)")
            }
        }
    }
}

#Preview {
    SettingsView()
}
