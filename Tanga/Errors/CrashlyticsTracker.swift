//
//  CrashlyticsTracker.swift
//  Tanga
//
//  Created by Rygel Louv on 21/02/2025.
//

import FirebaseCrashlytics

class CrashlyticsTracker: LogTree, ErrorTracker {
    func log(_ level: LogLevel, message: String, file: String, function: String, line: Int) {
        let logMessage = "[\(level)] \(message) (\(file):\(line) \(function))"
        Crashlytics.crashlytics().log(logMessage)
        
        if level == .error {
            let error = NSError(domain: file, code: 1, userInfo: [NSLocalizedDescriptionKey: message])
            Crashlytics.crashlytics().record(error: error)
        }
    }

    /// Sets the user ID for Crashlytics tracking
    func setUserId(_ userId: String) {
        Crashlytics.crashlytics().setUserID(userId)
    }

    /// Adds custom key-value pairs for debugging
    func setCustomKey(_ key: String, value: Any) {
        Crashlytics.crashlytics().setCustomValue(value, forKey: key)
    }

    /// Logs a non-fatal error
    func recordError(_ error: Error, userInfo: [String: Any]? = nil) {
        Crashlytics.crashlytics().record(error: error, userInfo: userInfo)
    }
    
    func clearUserId() {
        Crashlytics.crashlytics().setUserID(nil)
    }
}
