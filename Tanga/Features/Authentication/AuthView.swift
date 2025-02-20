//
//  AuthView.swift
//  Tanga
//
//  Created by Rygel Louv on 28/09/2024.
//

import AuthenticationServices
import SwiftUI
import OSLog

struct AuthView: View {
    @EnvironmentObject var authManager: AuthManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
           VStack {
               SkipButton(skipAuth: skipAuth, onDismiss: { dismiss() }, authState: authManager.authState)
               
               VStack {
                   Spacer()
                   
                   BookLoverImage()
                   
                   Spacer()
                   
                   WelcomeText()
                   Color.clear.frame(height: 1)
                   
                   SignInExplanation()
                   
                   Spacer()
                   
                   SignInWithAppleButton(
                       onRequest: { request in
                           AppleSignInManager.shared.requestAppleAuthorization(request)
                       },
                       onCompletion: { result in
                           handleAppleID(result)
                       }
                   ).signInWithAppleButtonStyle(.black)
                       
                       .frame(width: .infinity, height: 60, alignment: .center)
                       .padding(10)
                   
                   GoogleSignInButton(signInWithGoogle: signInWithGoogle)
                   
                   Color.clear.frame(height: 5)
                   
                   TermsAndPrivacyText()
                   
                   Color.clear.frame(height: 5)
               }.padding(.horizontal, 25)
           }
           .background(.white)
    }
    
    struct SkipButton: View {
        var skipAuth: () -> Void
        let onDismiss: () -> Void
        let authState: SessionState
        
        var body: some View {
            HStack {
                Spacer()
                Button(action: {
                    if authState == .anonymous {
                        onDismiss()
                    } else {
                        skipAuth()
                    }
                }) {
                    Text(text)
                        .frame(minHeight: 36)
                        .font(Font.custom("Montserrat", size: 16, relativeTo: .headline))
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                        .padding(.horizontal, 36)
                        .padding(.vertical, 4)
                        .background(Color.orangeTransparent)
                        .cornerRadius(100)
                }.padding(.horizontal, 10)
            }.padding(.top, 20)
        }
        
        private var text: String {
            authState == .anonymous ? "Close" : "Skip"
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
            Text("Sign in or Sign up with Google or Apple to start enjoying Tanga Now")
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
                Logger.authentication.info("Google Signin button tapped")
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
                let _ = try await authManager.signInAnonymously()
            }
            catch {
                Logger.authentication.error("Error signing in anonymously: \(error)")
            }
        }
    }
    
    func signInWithGoogle() {
        Task {
            do {
                guard let user = try await GoogleSignInManager.shared.signInWithGoogle() else { return }
                let result = try await authManager.googleAuth(user: user)
                if let result = result {
                    Logger.authentication.info("Google sign in successful: \(result.user.uid)")
                }
            }
            catch {
                Logger.authentication.error("GoogleSignInError: failed to sign in with Google, \(error))")
            }
        }
    }
    
    func handleAppleID(_ result: Result<ASAuthorization, Error>) {
        if case let .success(auth) = result {
            guard let appleIDCredentials = auth.credential as? ASAuthorizationAppleIDCredential else {
                print("AppleAuthorization failed: AppleID credential not available")
                return
            }

            Task {
                do {
                    guard let _ = try await authManager.appleAuth(
                        appleIDCredentials,
                        nonce: AppleSignInManager.nonce
                    ) else {
                        return
                    }
                    
                } catch {
                    debugPrint("AppleAuthorization failed: \(error.localizedDescription)")
                    // Show error
                }
            }
        }
        else if case let .failure(error) = result {
            print("AppleAuthorization failed: \(error)")
            // show error message to user.
        }
    }
}

#Preview {
    AuthView()
}
