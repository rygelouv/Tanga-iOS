//
//  SessionManager.swift
//  Tanga
//
//  Created by Rygel Louv on 19/02/2025.
//

import SwiftUI

protocol SessionManaging {
    func openSession(sessionId: String) async throws
    
    func hasSession() async throws -> Bool
    
    func clearSession() async throws
}

@MainActor
class SessionManager: SessionManaging {
    @AppStorage(sessionIdKey) var sessionId: String = ""
    
    func openSession(sessionId: String) async throws {
        self.sessionId = sessionId
        DefaultErrorTracker.shared.setUserId(sessionId)
    }
    
    func hasSession() async throws -> Bool {
        return !sessionId.isEmpty
    }
    
    func clearSession() async throws {
        sessionId = ""
        DefaultErrorTracker.shared.clearUserId()
    }
}
