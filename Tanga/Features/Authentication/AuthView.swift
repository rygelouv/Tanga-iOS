//
//  AuthView.swift
//  Tanga
//
//  Created by Rygel Louv on 28/09/2024.
//

import SwiftUI

struct AuthView: View {
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
           VStack {
               SkipButton(skipAuth: skipAuth)
               
               Spacer()
               
               BookLoverImage()
               
               Spacer()
               
               WelcomeText()
               Color.clear.frame(height: 1)
               
               SignInExplanation()
               
               Spacer()
               
               GoogleSignInButton(signInWithGoogle: signInWithGoogle)
               
               Color.clear.frame(height: 5)
               
               TermsAndPrivacyText()
               
               Color.clear.frame(height: 5)
           }
           .padding(.horizontal, 25)
           .background(.white)
    }
    
    struct SkipButton: View {
        var skipAuth: () -> Void
        
        var body: some View {
            HStack {
                Spacer()
                Button(action: {
                    print("Button tapped")
                    skipAuth()
                }) {
                    Text("Skip")
                        .frame(minHeight: 36)
                        .font(Font.custom("Montserrat", size: 16, relativeTo: .headline))
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                        .padding(.horizontal, 36)
                        .padding(.vertical, 4)
                        .background(Color.orangeTransparent)
                        .cornerRadius(100)
                }.padding(.horizontal, 10)
            }
        }
    }

    struct BookLoverImage: View {
        var body: some View {
            Image("book_lover")
                .resizable()
                .scaledToFit()
                .padding(.horizontal, 34)
        }
    }

    struct WelcomeText: View {
        var body: some View {
            Text("Welcome to Tanga")
                .fontWeight(.semibold)
                .font(Font.custom("Montserrat", size: 28, relativeTo: .title))
                .foregroundColor(.navy)
        }
    }

    struct SignInExplanation: View {
        var body: some View {
            Text("Sign in or Sign up with Google to start enjoying Tanga Now")
                .font(Font.custom("Montserrat", size: 16, relativeTo: .body))
                .fontWeight(.regular)
                .foregroundStyle(Color.auroMetalSaurus)
                .padding(.horizontal, 20)
                .multilineTextAlignment(.center)
        }
    }

    struct GoogleSignInButton: View {
        var signInWithGoogle : () -> Void
        
        var body: some View {
            Button(action: {
                print("Google Signin button tapped")
                signInWithGoogle()
            }) {
                ZStack {
                    HStack {
                        Image("google-icon").resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 28, height: 28)
                            .padding(.leading, 10)
                        Spacer()
                    }
                    Text("Sign In with Google")
                        .frame(maxWidth: .infinity)
                        .font(Font.custom("Montserrat", size: 15, relativeTo: .headline))
                        .fontWeight(.regular)
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity, minHeight: 28)
                .padding()
            }
            .background(.black)
            .cornerRadius(8).padding(.horizontal, 10)
        }
    }

    struct TermsAndPrivacyText: View {
        var body: some View {
            Text(.init("By using the app, you agree to our [Terms and Conditions](https://tanga.app/terms_and_conditions.html) and our [Privacy Policy](https://tanga.app/privacy_policy.html)"))
                .font(Font.custom("Montserrat", size: 12, relativeTo: .body))
                .fontWeight(.bold)
                .foregroundStyle(Color.auroMetalSaurus)
                .padding(.horizontal, 10)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .tint(.yaleBlue) // This sets the color of the links
                .environment(\.openURL, OpenURLAction { url in
                    UIApplication.shared.open(url)
                    return .handled
                })
        }
    }
    
    func skipAuth() {
        Task {
            do {
                try await authManager.signInAnonymously()
            }
            catch {
                print("Error signing in anonymously: \(error)")
            }
        }
    }
    
    func signInWithGoogle() {
        Task {
            do {
                guard let user = try await GoogleSignInManager.shared.signInWithGoogle() else { return }
                let result = try await authManager.googleAuth(user: user)
                if let result = result {
                    print("Google sign in successful: \(result.user.uid)")
                }
            }
            catch {
                print("GoogleSignInError: failed to sign in with Google, \(error))")
            }
        }
    }
}

#Preview {
    AuthView()
}
