//
//  AuthManager.swift
//  Tanga
//
//  Created by Rygel Louv on 04/10/2024.
//

import OSLog
import Foundation
import AuthenticationServices
import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import SwiftUI

typealias FirebaseUser = FirebaseAuth.User

/*enum AuthState {
    case anonymous // Anonymously authenticated in the app.
    case signedOut // Authenticated in Firebase using one of service providers, and not anonymous.
    case signedIn // Not authenticated in the app.
}*/

enum SigninProvider: String {
  case apple = "apple.com"
  case google = "google.com"
}

@MainActor
class AuthManager: ObservableObject {
    
    private let userRepository: UserRepository = UserRepository()
    
    @Published var user: FirebaseUser?
    @Published var authState: SessionState = .signedOut
    
    private var authStateHandle: AuthStateDidChangeListenerHandle!
    
    private let revenueCatController: RevenueCatController
    
    internal let appleAccountTerminator: AppleAccountTerminating
    internal let googleAccountTerminator: GoogleAccountTerminating
    
    internal let sessionManager: SessionManaging
    
    /// - Parameters:
    ///   - appleAccountTerminator: Manager for Apple account termination operations
    ///   - googleAccountTerminator: Manager for Google account termination operations
    init(
        appleAccountTerminator: AppleAccountTerminating = AppleAccountTerminator(),
        googleAccountTerminator: GoogleAccountTerminating = GoogleAccountTerminator()
    ) {
        // Account terminators
        self.appleAccountTerminator = appleAccountTerminator
        self.googleAccountTerminator = googleAccountTerminator
        
        // Subscription controller
        revenueCatController = RevenueCatController()
        
        // Session manager
        sessionManager = SessionManager()
        
        // Observing auth state
        authStateHandle = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            TangaLogger.shared.info("Auth state changed: \(user != nil ? "Signed in" : "Signed out")")
            self?.updateState(user: user)
        }
        
        // Verify AppleID and Google credentials
        Task {
            await verifySignInProvider()
        }
    }
    
    func updateState(user: FirebaseUser?) {
        self.user = user
        let isAuthenticated = user != nil
        let isAnonymous = user?.isAnonymous ?? false
        if !isAnonymous {
            createOrUpdateUser(user: user)
        }
        
        if isAuthenticated {
            self.authState = isAnonymous ? .anonymous : .signedIn
        } else {
            self.authState = .signedOut
        }
    }
    
    func createOrUpdateUser(user: FirebaseUser?) {
        Task {
            if let firebaseUser = user {
                let result = await userRepository.createUser(user: firebaseUser.toUser())
                switch result {
                case .success(let tangaUser):
                    guard let userId = tangaUser.id else { return }
                    try await sessionManager.openSession(sessionId: userId)
                    // Identify user in RevenueCat
                    await revenueCatController.login(sessionId: userId)
                case .failure(let error):
                    TangaLogger.shared.error("Error creating or updating user: \(error)")
                }
            }
        }
    }
    
    func removeAuthStateListener() {
        Auth.auth().removeStateDidChangeListener(authStateHandle)
    }
    
    func signInAnonymously() async throws -> AuthDataResult {
        do {
            let result = try await Auth.auth().signInAnonymously()
            TangaLogger.shared.info("Signed in anonymously: \(result.user.uid)")
            return result
        }
        catch {
            TangaLogger.shared.error("Error signing in anonymously: \(error)")
            throw error
        }
    }
    
    private func authenticateUser(credentials: AuthCredential) async throws -> AuthDataResult? {
        if Auth.auth().currentUser != nil {
            return try await authLink(credentials: credentials)
        } else {
            return try await authSignIn(credentials: credentials)
        }
    }
    
    private func authSignIn(credentials: AuthCredential) async throws -> AuthDataResult {
        do {
            let result = try await Auth.auth().signIn(with: credentials)
            TangaLogger.shared.info("Signed in: \(result.user.uid)")
            updateState(user: result.user)
            return result
        } catch {
            TangaLogger.shared.error("Error signing in: \(error)")
            throw error
        }
    }
    
    private func authLink(credentials: AuthCredential) async throws -> AuthDataResult? {
        do {
            guard let user = Auth.auth().currentUser else {
                return nil
            }
            let result = try await user.link(with: credentials)
            await updateDisplayName(for: result.user)
            updateState(user: result.user)
            return result
        } catch {
            TangaLogger.shared.error("Error linking: \(error)")
            throw error
        }
    }
    
    private func updateDisplayName(for user: FirebaseUser) async {
        let currentDisplayName = Auth.auth().currentUser?.displayName
        if currentDisplayName?.isEmpty == true {
            let displayName = user.providerData.first?.displayName ?? "Anonymous"
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = displayName
            do {
                try await changeRequest.commitChanges()
            } catch {
                TangaLogger.shared.error("Error updating display name: \(error)")
            }
        }
    }
    
    func googleAuth(user: GIDGoogleUser) async throws -> AuthDataResult? {
        guard let idToken = user.idToken?.tokenString else {return nil }
        
        let credentials = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
        do {
            return try await authenticateUser(credentials: credentials)
        } catch {
            TangaLogger.shared.error("Error authenticating user: \(error)")
            throw error
        }
    }
    
    func appleAuth(
        _ appleIdCredentials: ASAuthorizationAppleIDCredential,
        nonce: String?
    ) async throws -> AuthDataResult? {
        guard let nonce = nonce else {
            fatalError("Invalid state: a login callback was received, but no login was sent.")
        }
    
        guard let appleIdToken = appleIdCredentials.identityToken else {
            print("Unable to fetch identity token")
            return nil
        }
        
        guard let ideTokenString = String(data: appleIdToken, encoding: .utf8) else {
            print("Unable to serialize identity token as string from data \(appleIdToken.debugDescription)")
            return nil
        }
        
        // Initialize a Firebase credential, including the user's full name.
        let credentials = OAuthProvider.appleCredential(
            withIDToken: ideTokenString, rawNonce: nonce, fullName: appleIdCredentials.fullName
        )
        
        do {
            return try await authenticateUser(credentials: credentials)
        } catch {
            print("FirebaseAuthError: appleAuth: \(error)")
            throw error
        }
    }
    
    func signOut() async throws {
        if Auth.auth().currentUser != nil {
            do {
                firebaseProvidersSignOut()
                try Auth.auth().signOut()
                await revenueCatController.logout()
                try await sessionManager.clearSession()
                TangaLogger.shared.info("Signed out")
            }
            catch {
                TangaLogger.shared.error("Error signing out: \(error)")
                throw error
            }
        }
    }
    
    func firebaseProvidersSignOut() {
        let providers = user?.providerData.map { $0.providerID }.joined(separator: ",")
        
        if providers?.contains(SigninProvider.google.rawValue) == true {
            GoogleSignInManager.shared.signOutFromGoogle()
        }
    }
    
    // MARK: - Verify authentication

    /// Verify sign in providers, whether or not they have been revoked.
    private func verifySignInProvider() async {
        guard let providerData = Auth.auth().currentUser?.providerData else { return }
        var isAppleCredentialRevoked = false
        var isGoogleCredentialRevoked = false

        if providerData.contains(where: { $0.providerID == SigninProvider.apple.rawValue }) {
            isAppleCredentialRevoked = await !verifySignInWithAppleID()
        }

        if providerData.contains(where: { $0.providerID == SigninProvider.google.rawValue }) {
            isGoogleCredentialRevoked = await !verifyGoogleSignIn()
        }

        if isAppleCredentialRevoked && isGoogleCredentialRevoked {
            /// Sign out iff user not signed out, or signed in anonymously.
            if authState != .signedIn {
                do {
                    try await self.signOut()
                }
                catch {
                    print("FirebaseAuthError: verifySignInProvider() failed. \(error)")
                }
            }
        }
    }

    /// Verify AppleID provider.
    /// - Returns: Boolean indicates whether user is authorized, or authorization has been revoked
    private func verifySignInWithAppleID() async -> Bool {
        let appleIDProvider = ASAuthorizationAppleIDProvider()

        guard let providerData = Auth.auth().currentUser?.providerData,
              let appleProviderData = providerData.first(where: { $0.providerID == SigninProvider.apple.rawValue }) else {
            return false
        }

        do {
            let credentialState = try await appleIDProvider.credentialState(forUserID: appleProviderData.uid)
            return credentialState != .revoked && credentialState != .notFound
        }
        catch {
            return false
        }
    }

    /// Verify Google provider.
    /// - Returns: Boolean indicates whether user is authorized, or authorization has been revoked
    private func verifyGoogleSignIn() async -> Bool {
        guard let providerData = Auth.auth().currentUser?.providerData,
              providerData.contains(where: { $0.providerID == SigninProvider.google.rawValue }) else { return false }

        do {
            try await GIDSignIn.sharedInstance.restorePreviousSignIn()
            return true
        }
        catch {
            return false // The Google sign in credential is either revoked or was not found.
        }
    }
}
