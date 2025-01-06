//
//  TangaApp.swift
//  Tanga
//
//  Created by Rygel Louv on 22/09/2024.
//

import SwiftUI
import FirebaseCore
import FirebaseStorage

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

    return true
  }
}

@main
struct TangaApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject var authManager: AuthManager
    
    @StateObject private var audioPlayerViewModel = AudioPlayerViewModel(
        urlDownloadGenerator: DownloadUrlGenerator(storage: Storage.storage()),
        audioController: AudioController()
    )
    
    init() {
        FirebaseApp.configure()
        
        let authManager = AuthManager()
        _authManager = StateObject(wrappedValue: authManager)
    }
    
    var body: some Scene {
        
        WindowGroup {
            MainView().environmentObject(authManager).environmentObject(audioPlayerViewModel)
        }
    }
}
