//
//  AuthManager+DeleteAccount.swift
//  Tanga
//
//  Created by Rygel Louv on 11/02/2025.
//

import AuthenticationServices
import FirebaseAuth
import GoogleSignIn
import OSLog

// MARK: - Protocols

/// Protocol defining the core authentication management functionality
protocol AccountDeletionManaging {
    /// Deletes the current user's account and revokes all associated provider access
    /// - Throws: AuthError if deletion fails or user is not found
    func deleteUserAccount() async throws
    
    /// Reauthenticates the user if their last sign-in is too old
    /// - Parameter user: The Firebase User to reauthenticate
    /// - Throws: AuthError if reauthentication fails
    func reauthenticateIfNeeded(_ user: FirebaseAuth.User) async throws
}

/// Protocol for handling Apple ID account deletion and access revocation
protocol AppleAccountTerminating {
    /// Reauthenticates a user using their Apple ID credentials for account deletion
    /// - Parameters:
    ///   - user: The Firebase User to reauthenticate
    ///   - credential: The Apple ID credential to use for reauthentication
    /// - Throws: AuthError if reauthentication fails or credentials are invalid
    func reauthenticate(user: FirebaseAuth.User, credential: ASAuthorizationAppleIDCredential) async throws
    
    /// Revokes the app's access to the user's Apple ID and prepares for account deletion
    /// - Parameter credential: The Apple ID credential to revoke
    /// - Throws: AuthError if revocation fails
    func revokeAccess(credential: ASAuthorizationAppleIDCredential) async throws
}

/// Protocol for handling Google account deletion and access revocation
protocol GoogleAccountTerminating {
    /// Reauthenticates a user using their Google account for deletion
    /// - Parameter user: The Firebase User to reauthenticate
    /// - Throws: AuthError if reauthentication fails
    func reauthenticate(user: FirebaseAuth.User) async throws
    
    /// Revokes the app's access to the user's Google account and prepares for deletion
    /// - Throws: AuthError if revocation fails
    func revokeAccess() async throws
}

// MARK: Auth Manager Account Deletion

// Inspired from https://medium.com/firebase-developers/deleting-user-account-revoke-access-token-0e30d7a351bb
extension AuthManager: AccountDeletionManaging {
    
    // MARK: - Public Methods
        
    func deleteUserAccount() async throws {
        // Verify user exists and get their last sign-in date
        guard let user = Auth.auth().currentUser,
              let lastSignInDate = user.metadata.lastSignInDate else {
            throw AuthError.userNotFound
        }
        
        let providers = user.providerData.map { $0.providerID }
        
        do {
            // Step 1: Reauthenticate if necessary
            try await refreshAuthenticationIfStale(user, lastSignInDate: lastSignInDate, providers: providers)
            
            // Step 2: Revoke access for all providers
            try await revokeProviderAccess(for: providers)
            
            // Step 3: Delete the user account
            try await user.delete()
            
            Logger.authentication.info("Successfully deleted user account")
            
            // Remove Session Id and change auth state to trigger navigation to auth screen
            sessionId = ""
            self.authState = .signedOut
        } catch {
            Logger.authentication.error("Failed to delete user account: \(error.localizedDescription)")
            throw AuthError.deletionFailed(underlying: error)
        }
    }
    
    func reauthenticateIfNeeded(_ user: FirebaseAuth.User) async throws {
        guard let lastSignInDate = user.metadata.lastSignInDate else {
            throw AuthError.userNotFound
        }
        
        let providers = user.providerData.map { $0.providerID }
        try await refreshAuthenticationIfStale(user, lastSignInDate: lastSignInDate, providers: providers)
    }
        
    // MARK: - Private Methods
    
    /// Reauthenticates the user if their last sign-in is older than 1 minute
    /// - Parameters:
    ///   - user: The Firebase User to reauthenticate
    ///   - lastSignInDate: User's last sign-in date
    ///   - providers: Array of authentication provider IDs
    private func refreshAuthenticationIfStale(
        _ user: FirebaseAuth.User,
        lastSignInDate: Date,
        providers: [String]
    ) async throws {
        // Skip reauthentication if the last sign-in was recent
        guard !lastSignInDate.isWithinPast(minutes: 1) else { return }
        
        // Reauthenticate with each provider
        for provider in providers {
            switch provider {
            case SigninProvider.apple.rawValue:
                let credential = try await AppleSignInManager.shared.requestAppleAuthorization()
                try await appleAccountTerminator.reauthenticate(user: user, credential: credential)
                
            case SigninProvider.google.rawValue:
                try await googleAccountTerminator.reauthenticate(user: user)
                
            default:
                Logger.authentication.warning("Unsupported provider: \(provider)")
            }
        }
    }
        
    /// Revokes access for all authentication providers
    /// - Parameter providers: Array of provider IDs to revoke
    private func revokeProviderAccess(for providers: [String]) async throws {
        for provider in providers {
            switch provider {
            case SigninProvider.apple.rawValue:
                let credential = try await AppleSignInManager.shared.requestAppleAuthorization()
                try await appleAccountTerminator.revokeAccess(credential: credential)
                
            case SigninProvider.google.rawValue:
                try await googleAccountTerminator.revokeAccess()
                
            default:
                Logger.authentication.warning("Unsupported provider: \(provider)")
            }
        }
    }
}

// MARK: Provider account terminators

/// Manager for Apple ID account termination operations
final class AppleAccountTerminator: AppleAccountTerminating {
    func reauthenticate(user: FirebaseAuth.User, credential: ASAuthorizationAppleIDCredential) async throws {
        // Extract and validate the Apple ID token
        guard let appleIDToken = credential.identityToken,
              let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            throw AuthError.tokenMissing
        }
        
        // Create OAuth credential for Firebase
        let nonce = AppleSignInManager.nonce
        let oauthCredential = OAuthProvider.credential(
            withProviderID: SigninProvider.apple.rawValue,
            idToken: idTokenString,
            rawNonce: nonce ?? ""
        )
        
        do {
            try await user.reauthenticate(with: oauthCredential)
        } catch {
            throw AuthError.reauthenticationFailed(provider: "Apple")
        }
    }
    
    func revokeAccess(credential: ASAuthorizationAppleIDCredential) async throws {
        guard let authorizationCode = credential.authorizationCode,
              let authCodeString = String(data: authorizationCode, encoding: .utf8) else {
            throw AuthError.credentialInvalid
        }
        
        do {
            try await Auth.auth().revokeToken(withAuthorizationCode: authCodeString)
        } catch {
            throw AuthError.revocationFailed(provider: "Apple")
        }
    }
}

/// Manager for Google account termination operations
final class GoogleAccountTerminator: GoogleAccountTerminating {
    func reauthenticate(user: FirebaseAuth.User) async throws {
        guard let googleUser = try await GoogleSignInManager.shared.signInWithGoogle(),
              let idToken = googleUser.idToken?.tokenString else {
            throw AuthError.credentialInvalid
        }
        
        let credential = GoogleAuthProvider.credential(
            withIDToken: idToken,
            accessToken: googleUser.accessToken.tokenString
        )
        
        do {
            try await user.reauthenticate(with: credential)
        } catch {
            throw AuthError.reauthenticationFailed(provider: "Google")
        }
    }
    
    func revokeAccess() async throws {
        do {
            try await GIDSignIn.sharedInstance.disconnect()
        } catch {
            throw AuthError.revocationFailed(provider: "Google")
        }
    }
}

// MARK: - Date Extension

extension Date {
    /// Checks if the date falls within the specified number of minutes from now
    /// - Parameter minutes: Number of minutes to check
    /// - Returns: Boolean indicating if the date is within the specified time range
    func isWithinPast(minutes: Int) -> Bool {
        let now = Date.now
        let timeAgo = now.addingTimeInterval(-1 * TimeInterval(60 * minutes))
        return (timeAgo...now).contains(self)
    }
}

// MARK: - Auth Errors

/// Comprehensive error type for authentication-related operations
enum AuthError: LocalizedError {
    /// User is not found or not currently signed in
    case userNotFound
    /// Account deletion failed with the specified underlying error
    case deletionFailed(underlying: Error)
    /// The provided authentication credential is invalid
    case credentialInvalid
    /// Required authentication token is missing
    case tokenMissing
    /// Reauthentication failed for the specified provider
    case reauthenticationFailed(provider: String)
    /// Access revocation failed for the specified provider
    case revocationFailed(provider: String)
    
    var errorDescription: String? {
        switch self {
        case .userNotFound:
            return "User not found or not signed in"
        case .deletionFailed(let error):
            return "Failed to delete user account: \(error.localizedDescription)"
        case .credentialInvalid:
            return "Invalid authentication credential"
        case .tokenMissing:
            return "Authentication token is missing"
        case .reauthenticationFailed(let provider):
            return "Failed to reauthenticate with \(provider)"
        case .revocationFailed(let provider):
            return "Failed to revoke access for \(provider)"
        }
    }
}
