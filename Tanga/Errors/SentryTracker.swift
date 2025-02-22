//
//  SentryTracker.swift
//  Tanga
//
//  Created by Rygel Louv on 21/02/2025.
//

import Sentry

class SentryTracker: ErrorTracker {
    
    func initialize() {
        guard let dsn = Bundle.main.object(forInfoDictionaryKey: "SENTRY_DSN") as? String else {return}
        SentrySDK.start { options in
            options.dsn = dsn
            options.debug = false // Enabling only when necessary - otherwise too noisy
            options.tracesSampleRate = 1.0 // May need to be adjusted later for production
            options.profilesSampleRate = 1.0
            options.sessionReplay.sessionSampleRate = 1.0
            options.attachScreenshot = true
            options.attachStacktrace = true
            options.attachViewHierarchy = true
        }
    }
    
    func setUserId(_ userId: String) {
        let user = Sentry.User()
        user.userId = userId
        SentrySDK.setUser(user)
    }
    
    func clearUserId() {
        SentrySDK.setUser(nil)
    }
}
