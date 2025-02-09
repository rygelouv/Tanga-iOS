//
//  NotificationHandler.swift
//  Tanga
//
//  Created by Rygel Louv on 08/02/2025.
//

import SwiftUI
import UserNotifications

// Class responsible for handling an incoming remote notification.
class NotificationHandler {
    static let shared = NotificationHandler()
    
    // Get the notification data, check the topic, process the data and build and show a local notification
    func handleNotification(_ notificationData: [AnyHashable: Any]) {
        
        // We only support weekly summary notifications for now. More implementation will be needed to support other topics later on
        let topic = notificationData[NotificationConstants.topic] as? String
        if topic != Topics.weeklySummary {
            print("Unsupported notification topic: \(String(describing: topic))")
            return
        }
        
        // Extract the data directly from notificationData
        let title = notificationData[NotificationConstants.title] as? String ?? ""
        let author = notificationData[NotificationConstants.author] as? String ?? ""
        let coverImageUrl = notificationData[NotificationConstants.coverImageUrl] as? String ?? ""
        // Deep link is not used yet for now
        let deepLink = notificationData[NotificationConstants.deepLink] as? String ?? ""
        
        // Create notification content
        let content = UNMutableNotificationContent()
        content.title = "📚 New free Weekly Summary Available!"
        content.body = "\(title) by \(author) - Check it out now! 👉"
        content.sound = .default
        
        // Download image if available
        if !coverImageUrl.isEmpty {
            NotificationImageDownloader.shared.downloadImage(from: coverImageUrl) { localImageUrl in
                if let localImageUrl = localImageUrl {
                    do {
                        // Create attachment with downloaded image
                        let attachment = try UNNotificationAttachment(
                            identifier: UUID().uuidString,
                            url: localImageUrl,
                            options: nil
                        )
                        content.attachments = [attachment]
                    } catch {
                        print("Error creating notification attachment: \(error)")
                    }
                }
                self.showNotification(content: content)
            }
        } else {
            showNotification(content: content)
        }
    }
    
    private func showNotification(content: UNMutableNotificationContent) {
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error showing notification: \(error)")
            }
        }
    }
}
