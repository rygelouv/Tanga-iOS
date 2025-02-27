//
//  TangaApp.swift
//  Tanga
//
//  Created by Rygel Louv on 22/09/2024.
//

import SwiftUI
import FirebaseCore
import FirebaseStorage
import FirebaseMessaging
import RevenueCat
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate {
    let gcmMessageIDKey = "gcm.message_id"

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {

        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self
        } else {
          let settings: UIUserNotificationSettings =
          UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
        
        Messaging.messaging().delegate = self
        
        return true
    }
}

@main
struct TangaApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject var authManager: AuthManager
    @StateObject var notificationPermissionManager: NotificationPermissionManager
    
    @StateObject private var audioPlayerViewModel = AudioPlayerViewModel(
        urlDownloadGenerator: DownloadUrlGenerator(storage: Storage.storage()),
        audioController: AudioController()
    )
    
    private let revenueCatController: RevenueCatController = RevenueCatController()
    private let sentryTracker = SentryTracker()
    private let crashlyticsTracker = CrashlyticsTracker()
    private let osLogger = OSLogger()
    
    init() {
        FirebaseApp.configure()
        
        let authManager = AuthManager()
        _authManager = StateObject(wrappedValue: authManager)
        
        let notificaitonManager = NotificationPermissionManager()
        _notificationPermissionManager = StateObject(wrappedValue: notificaitonManager)
        
        revenueCatController.initialize()
        sentryTracker.initialize()
        AnalyitcsConfig.shared.initialize()
        
        TangaLogger.shared.plant(osLogger)
        TangaLogger.shared.plant(crashlyticsTracker)
    }
    
    var body: some Scene {
        
        WindowGroup {
            MainView()
                .environmentObject(authManager)
                .environmentObject(audioPlayerViewModel)
                .environmentObject(notificationPermissionManager)
        }
    }
}
