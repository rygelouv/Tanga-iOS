//
//  SessionManager.swift
//  Tanga
//
//  Created by Rygel Louv on 19/02/2025.
//

import SwiftUI

protocol SessionManaging {
    func hasSession() async -> Bool
}

@MainActor
class SessionManager: SessionManaging {
    @AppStorage(sessionIdKey) var sessionId: String = ""
    
    func hasSession() async -> Bool {
        return !sessionId.isEmpty
    }
}
