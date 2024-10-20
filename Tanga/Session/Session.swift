//
//  Session.swift
//  Tanga
//
//  Created by Rygel Louv on 20/10/2024.
//

enum SessionState {
    case anonymous // Anonymously authenticated in the app.
    case signedOut // Authenticated in Firebase using one of service providers, and not anonymous.
    case signedIn // Not authenticated in the app.
}

let sessionIdKey: String = "sessionId"
