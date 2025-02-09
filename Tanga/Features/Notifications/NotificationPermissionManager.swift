//
//  NotificationPermissionManager.swift
//  Tanga
//
//  Created by Rygel Louv on 29/01/2025.
//

import SwiftUI
import OSLog

// Manages the logic to request notification permission
// To avoid spaming users, we should only request for permission under certain conditions
// Which is every 4 launches and only within a 24h delay
@MainActor
class NotificationPermissionManager: ObservableObject {
    @Published private(set) var hasPermission = false
    private let defaults = UserDefaults.standard
    private let lastPromptKey = "lastNotificationPromptDate"
    private let launchCountKey = "appLaunchCount"
    
    init() {
        incrementLaunchCount()
        
        Task {
            await getAuthStatus()
        }
    }
    
    
    private func incrementLaunchCount() {
        let count = defaults.integer(forKey: launchCountKey)
        defaults.set(count + 1, forKey: launchCountKey)
    }
    
    func shouldShowNotificationView() async -> Bool {
        await getAuthStatus()
        
        // If already has permission, never show
        if hasPermission {
            return false
        }
        
        let currentLaunchCount = defaults.integer(forKey: launchCountKey)
        
        // If it's first or 4th launch or multiple of 4
        if currentLaunchCount == 1 || currentLaunchCount % NotificationConstants.launchCount == 0 {
            // Check if we've shown prompt recently (within last 24h)
            if let lastPrompt = defaults.object(forKey: lastPromptKey) as? Date {
                let hoursSinceLastPrompt = Calendar.current.dateComponents([.hour], from: lastPrompt, to: Date()).hour ?? 0
                
                // Only show if last prompt was more than 24h ago
                if hoursSinceLastPrompt >= NotificationConstants.launchDelay {
                    defaults.set(Date(), forKey: lastPromptKey)
                    return true
                }
            } else {
                // No last prompt recorded, show itpk
                defaults.set(Date(), forKey: lastPromptKey)
                return true
            }
        }
        
        return false
    }
    
    func request() async {
        do {
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            try await UNUserNotificationCenter.current().requestAuthorization(options: authOptions)
            await getAuthStatus()
        } catch {
            print(error)
        }
    }
    
    func getAuthStatus() async {
        let status = await UNUserNotificationCenter.current().notificationSettings()
        switch status.authorizationStatus {
        case .authorized, .ephemeral, .provisional:
            hasPermission = true
        default:
            hasPermission = false
        }
    }
}
