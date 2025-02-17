//
//  GoogleSignInManager.swift
//  Tanga
//
//  Created by Rygel Louv on 05/10/2024.
//

import GoogleSignIn

class GoogleSignInManager {
    
    static let shared = GoogleSignInManager()
    
    typealias GoogleAuthResult = (GIDGoogleUser?, Error?) -> Void
    
    private init() {}
    
    @MainActor
    func signInWithGoogle() async throws -> GIDGoogleUser? {
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            do {
                try await GIDSignIn.sharedInstance.restorePreviousSignIn()
                // 1.
                return try await GIDSignIn.sharedInstance.currentUser?.refreshTokensIfNeeded()
            }
            catch {
                // 2.
                return try await googleSignInFlow()
            }
        } else {
            return try await googleSignInFlow()
        }
    }

    @MainActor
    private func googleSignInFlow() async throws -> GIDGoogleUser? {
        // Otherwise, move on to the regular sign-in process.
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return nil }
        guard let rootViewController = windowScene.windows.first?.rootViewController else { return nil }
        
        // Start the sign-in process by calling signIn() from the shared instance of the GIDSignIn class.
        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
        return result.user
    }
    
    func signOutFromGoogle() {
        GIDSignIn.sharedInstance.signOut()
    }
}
