//
//  NotificationImageDownloader.swift
//  Tanga
//
//  Created by Rygel Louv on 08/02/2025.
//

import SwiftUI
import OSLog

// Handle the download of notification images using their urls
class NotificationImageDownloader {
    static let shared = NotificationImageDownloader()
    
    private init() {}
    
    func downloadImage(from urlString: String,
                      completion: @escaping (URL?) -> Void) {
        guard let imageUrl = URL(string: urlString) else {
            Logger.notifications.error("Invalid image URL")
            completion(nil)
            return
        }
        
        URLSession.shared.downloadTask(with: imageUrl) { tempFileUrl, response, error in
            if let error = error {
                print("Error downloading image: \(error)")
                completion(nil)
                return
            }
            
            guard let tempFileUrl = tempFileUrl else {
                Logger.notifications.error("No image file downloaded")
                completion(nil)
                return
            }
            
            do {
                // Create a local file URL in the temporary directory
                let fileManager = FileManager.default
                let localImageUrl = URL(fileURLWithPath: NSTemporaryDirectory())
                    .appendingPathComponent(UUID().uuidString)
                    .appendingPathExtension("jpg")
                
                // Move the downloaded file to our local URL
                try? fileManager.removeItem(at: localImageUrl) // Remove any existing file
                try fileManager.moveItem(at: tempFileUrl, to: localImageUrl)
                
                completion(localImageUrl)
            } catch {
                print("Error saving image: \(error)")
                completion(nil)
            }
        }.resume()
    }
}
