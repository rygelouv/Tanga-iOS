//
//  SettingsView.swift
//  Tanga
//
//  Created by Rygel Louv on 06/01/2025.
//

import OSLog
import SwiftUI

struct SettingsView: View {
    @Binding var path: NavigationPath
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authManager: AuthManager
    
    @State private var showLogoutAlert = false
    
    var body: some View {
        ZStack {
            VStack {
                ProfileContentAction(
                    imageName: "insurance",
                    text: "Logout",
                    color: .red,
                    paddingValue: 12,
                    onClick: { showLogoutAlert = true }
                )
                .background(Color.white)
                .alert("Confirm Logout", isPresented: $showLogoutAlert) {
                    Button("Yes", role: .destructive) {
                        onSignOut()
                    }
                    Button("No", role: .cancel) { }
                } message: {
                    Text("Are you sure you want to logout?")
                }
                
                Spacer()
                
                VersionView()
                
                TangaButton(
                    onButtonTap: {
                        path.append(ProfileNavigationDestinations.DeleteAccount)
                    },
                    text: "Delete Account",
                    variation: ButtonVariation.danger
                )
            }
        }.background(Color.cultured)
    }
    
    struct VersionView: View {
        var body: some View {
            HStack {
                Text("Tanga Version: \(getAppVersion())")
                    .font(Font.custom("Montserrat", size: 12, relativeTo: .body))
                    .fontWeight(.regular)
                    .foregroundStyle(Color.auroMetalSaurus)
                Text("(\(getBuildNumber()))")
                    .font(Font.custom("Montserrat", size: 12, relativeTo: .body))
                    .fontWeight(.regular)
                    .foregroundStyle(Color.auroMetalSaurus)
            }
        }

        func getAppVersion() -> String {
            if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                return appVersion
            }
            return "Unknown"
        }

        func getBuildNumber() -> String {
            if let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
                return buildNumber
            }
            return "Unknown"
        }
    }
    
    func onSignOut() {
        Task {
            do {
                try await authManager.signOut()
                dismiss()
            } catch {
                Logger.settings.error("Error signing out: \(error)")
            }
        }
    }
}

#Preview {
    SettingsView(path: .constant(NavigationPath()))
}
