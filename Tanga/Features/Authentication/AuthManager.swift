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

enum AuthState {
    case anonymous // Anonymously authenticated in the app.
    case signedOut // Authenticated in Firebase using one of service providers, and not anonymous.
    case signedIn // Not authenticated in the app.
}


@MainActor
class AuthManager: ObservableObject {
    @AppStorage(sessionIdKey) var sessionId: String = ""
    
    private let userRepository: UserRepository = UserRepository()
    
    @Published var user: FirebaseUser?
    @Published var authState: AuthState = .signedOut
    
    private var authStateHandle: AuthStateDidChangeListenerHandle!
    
    private var revenueCatController: RevenueCatController
    
    init() {
        revenueCatController = RevenueCatController()
        authStateHandle = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            Logger.authentication.info("Auth state changed: \(user != nil ? "Signed in" : "Signed out")")
            self?.updateState(user: user)
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
                    sessionId = userId
                    // Identify user in RevenueCat
                    await revenueCatController.login(sessionId: sessionId)
                case .failure(let error):
                    Logger.authentication.error("Error creating or updating user: \(error)")
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
            Logger.authentication.info("Signed in anonymously: \(result.user.uid)")
            return result
        }
        catch {
            Logger.authentication.error("Error signing in anonymously: \(error)")
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
            Logger.authentication.info("Signed in: \(result.user.uid)")
            updateState(user: result.user)
            return result
        } catch {
            Logger.authentication.error("Error signing in: \(error)")
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
            Logger.authentication.error("Error linking: \(error)")
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
                Logger.authentication.error("Error updating display name: \(error)")
            }
        }
    }
    
    func googleAuth(user: GIDGoogleUser) async throws -> AuthDataResult? {
        guard let idToken = user.idToken?.tokenString else {return nil }
        
        let credentials = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
        do {
            return try await authenticateUser(credentials: credentials)
        } catch {
            Logger.authentication.error("Error authenticating user: \(error)")
            throw error
        }
    }
    
    func signOut() async throws {
        if Auth.auth().currentUser != nil {
            do {
                firebaseProvidersSignOut()
                try Auth.auth().signOut()
                await revenueCatController.logout()
                Logger.authentication.info("Signed out")
            }
            catch {
                Logger.authentication.error("Error signing out: \(error)")
                throw error
            }
        }
    }
    
    func firebaseProvidersSignOut() {
        let providers = user?.providerData.map { $0.providerID }.joined(separator: ",")
        
        if providers?.contains("google.com") == true {
            GoogleSignInManager.shared.signOutFromGoogle()
        }
    }
}
