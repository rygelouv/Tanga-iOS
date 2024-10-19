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
        // Check if a user has previously signed in. If yes, then restore and return the user’s sign-in.
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            return try await GIDSignIn.sharedInstance.restorePreviousSignIn()
        } else {
            // Otherwise, move on to the regular sign-in process.
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return nil }
            guard let rootViewController = windowScene.windows.first?.rootViewController else { return nil }
            
            // Start the sign-in process by calling signIn() from the shared instance of the GIDSignIn class.
            let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
            return result.user
        }
    }
    
    func signOutFromGoogle() {
        GIDSignIn.sharedInstance.signOut()
    }
}
