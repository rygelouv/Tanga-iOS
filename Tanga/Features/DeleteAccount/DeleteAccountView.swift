//
//  DeleteAccountView.swift
//  Tanga
//
//  Created by Rygel Louv on 11/02/2025.
//

import SwiftUI

struct DeleteAccountView: View {
    @Binding var accountDeleted: Bool
    @State private var showDeleteAlert = false
    @State private var showDeleteErrorAlert = false
    @State private var showLoading = false
    @EnvironmentObject var authManager: AuthManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                ScrollView {
                    VStack(spacing: 0) {
                        // Content VStack
                        VStack {
                            DeletionImage()
                            
                            Text("Delete Your Tanga Account")
                                .fontWeight(.bold)
                                .font(Font.custom("Montserrat", size: 22, relativeTo: .title))
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                                .padding(.top, 14)
                                .padding(.bottom, 24)
                                .padding(.horizontal, 12)
                            
                            DescriptionText()
                        }
                        
                        // Spacer that pushes buttons to bottom
                        Spacer(minLength: 0)
                        
                        // Buttons VStack
                        VStack(spacing: 16) {
                            TangaButton(
                                onButtonTap: {
                                    dismiss()
                                },
                                text: "Keep My Account"
                            )
                            
                            TangaButton(
                                onButtonTap: {
                                    showDeleteAlert = true
                                },
                                text: "Delete Account",
                                variation: ButtonVariation.danger
                            )
                            .alert("Confirm Deletion", isPresented: $showDeleteAlert) {
                                Button("Yes Delete", role: .destructive) {
                                    self.showLoading = true
                                    Task {
                                        do {
                                            try await authManager.deleteUserAccount()
                                            print("user deleted")
                                            self.accountDeleted = true
                                            dismiss()
                                        } catch {
                                            self.showLoading = false
                                            showDeleteErrorAlert = true
                                        }
                                    }
                                }
                                Button("Cancel", role: .cancel) { }
                            } message: {
                                Text("Please confirm you want to delete your account. This action is permanent and cannot be undone.")
                            }
                            .alert("Deletion Error", isPresented: $showDeleteErrorAlert) {
                                Button("Ok", role: .destructive) { }
                            } message: {
                                Text("An error occurred while attempting to delete your account. Please try again later.")
                            }
                        }
                        .padding(.top, 24)
                    }
                    .frame(minHeight: geometry.size.height)
                    .padding()
                }
            }
            
            if showLoading {
                LoadingView()
            }
        }
    }
    
    struct DeletionImage: View {
        var body: some View {
            Image("graphic_man_thinking")
                .resizable()
                .scaledToFit()
                .padding(.horizontal, 68)
        }
    }
    
    struct DescriptionText: View {
        var body: some View {
            Text(
                """
                Are you sure you want to say goodbye to your Tanga account? This action is permanent and cannot be undone. Here's what you'll miss out on:\n
                    - All your saved book summaries\n
                    - Any premium content or features you purchased \n
                If you're sure you want to go, click "Delete Account" below. If you have any questions or need a hand, our support team is here to help!
                """)
                .font(Font.custom("Montserrat", size: 14, relativeTo: .body))
                .fontWeight(.regular)
                .foregroundColor(.auroMetalSaurus)
        }
    }
}

#Preview {
    DeleteAccountView(accountDeleted: .constant(false)).environmentObject(AuthManager())
}
