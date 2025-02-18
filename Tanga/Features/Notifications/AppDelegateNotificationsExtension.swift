//
//  AppDelegateNotificationsExtension.swift
//  Tanga
//
//  Created by Rygel Louv on 29/01/2025.
//

import SwiftUI
import FirebaseMessaging
import UserNotifications
import OSLog


extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {

      let deviceToken:[String: String] = ["token": fcmToken ?? ""]
        print("Device token: ", deviceToken)
        
        Messaging.messaging().subscribe(toTopic: Topics.weeklySummary) { error in
            if let error = error {
                print("Error subscribing to topic: \(error)")
            } else {
                Logger.notifications.info("Successfully subscribed to topic: \(Topics.weeklySummary)")
            }
        }
    }
}

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {

  // Receive displayed notifications for iOS 10 devices.
   func userNotificationCenter(_ center: UNUserNotificationCenter,willPresent notification: UNNotification,nwithCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo

        if let messageID = userInfo[gcmMessageIDKey] {
            //TODO: we should only log this in debug/dev and never in production
            print("willPresent -> Message ID: \(messageID)")
        }

        completionHandler([[.banner, .badge, .sound]])
   }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Logger.notifications.info("Registered for apple notification")
        Messaging.messaging().setAPNSToken(deviceToken, type: .unknown)
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        Logger.notifications.info("Falied to register for apple notification")
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
      let userInfo = response.notification.request.content.userInfo

      if let messageID = userInfo[gcmMessageIDKey] {
          //TODO: we should only log this in debug/dev and never in production
          print("Message ID from userNotificationCenter didReceive: \(messageID)")
      }

        Logger.notifications.info("Notification message ===> \(userInfo)")

      completionHandler()
    }
    
    func application(_ application: UIApplication,
                    didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                    fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        print("Notification remote message ===> \(userInfo)")
        
        let handler = NotificationHandler.shared
        handler.handleNotification(userInfo)

        completionHandler(UIBackgroundFetchResult.newData)
    }
}
