//
//  AuthManager.swift
//  Tanga
//
//  Created by Rygel Louv on 04/10/2024.
//

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
    
    let userRepository: UserRepository = UserRepository()
    
    @Published var user: FirebaseUser?
    @Published var authState: AuthState = .signedOut
    
    private var authStateHandle: AuthStateDidChangeListenerHandle!
    
    init() {
        // trySignOut() // TODO to be removed later
        authStateHandle = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            print("Auth state changed: \(user != nil ? "Signed in" : "Signed out")")
            self?.updateState(user: user)
        }
    }
    
    func trySignOut() {
        Task {
            do {
                try await signOut()
            }
            catch {
                print("Error: \(error)")
            }
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
                    sessionId = tangaUser.id ?? UUID().uuidString
                case .failure(let error):
                    print("Error creating or updating user: \(error)")
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
            print("Signed in anonymously: \(result.user.uid)")
            return result
        }
        catch {
            print("Error signing in anonymously: \(error)")
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
            print("Signed in: \(result.user.uid)")
            updateState(user: result.user)
            return result
        } catch {
            print("Error signing in: \(error)")
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
            print("Error linking: \(error)")
            throw error
        }
    }
    
    private func updateDisplayName(for user: FirebaseUser) async {
        let currentDisplayName = Auth.auth().currentUser?.displayName
        if currentDisplayName?.isEmpty == true {
            let displayName = user.providerData.first?.displayName
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = displayName
            do {
                try await changeRequest.commitChanges()
            } catch {
                print("Error updating display name: \(error)")
            }
        }
    }
    
    func googleAuth(user: GIDGoogleUser) async throws -> AuthDataResult? {
        guard let idToken = user.idToken?.tokenString else {return nil }
        
        let credentials = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
        do {
            return try await authenticateUser(credentials: credentials)
        } catch {
            print("Error authenticating user: \(error)")
            throw error
        }
    }
    
    func signOut() async throws {
        if Auth.auth().currentUser != nil {
            do {
                firebaseProvidersSignOut()
                try Auth.auth().signOut()
                print("Signed out")
            }
            catch {
                print("Error signing out: \(error)")
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
