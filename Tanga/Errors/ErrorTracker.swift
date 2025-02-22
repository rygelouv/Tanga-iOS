//
//  ErrorTracker.swift
//  Tanga
//
//  Created by Rygel Louv on 22/02/2025.
//

protocol ErrorTracker {
    
    func setUserId(_ userId: String)
    
    func clearUserId()
}

class DefaultErrorTracker {
    static let shared = DefaultErrorTracker()
    let crashlyticsTracker: CrashlyticsTracker
    let sentryTracker: SentryTracker
    
    private init() {
        self.crashlyticsTracker = CrashlyticsTracker()
        self.sentryTracker = SentryTracker()
    }
    
    func setUserId(_ userId: String) {
        crashlyticsTracker.setUserId(userId)
        sentryTracker.setUserId(userId)
    }
    
    func clearUserId() {
        crashlyticsTracker.clearUserId()
        sentryTracker.clearUserId()
    }
}
