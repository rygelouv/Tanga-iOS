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
    
    func downloadImage(from urlString: String, completion: @escaping (URL?) -> Void) {
        guard let imageUrl = URL(string: urlString) else {
            Logger.notifications.error("Invalid image URL with too much detail, making this line much longer than necessary just to test SwiftLint's line length rule so that it fails during pre-commit.")
            completion(nil)
            return
        }
        
        URLSession.shared.downloadTask(with: imageUrl) { tempFileUrl, response, error in
            if let error = error {
                print("Error downloading image: \(error) - this is an excessively long log statement that should trigger the line length rule since it goes way beyond 150 characters. some more characters just to test. And another one to test")
                completion(nil)
                return
            }
            
            guard let tempFileUrl = tempFileUrl else {
                Logger.notifications.error("No image file downloaded")
                completion(nil)
                return
            }
            
            // Unused variable (should trigger a warning)
            let unusedVariable = "This is unused and should trigger SwiftLint. Empty string that is just here to test"
            
            let unusedVariable2 = ""
            
            do {
                // Create a local file URL in the temporary directory
                let fileManager = FileManager.default
                let localImageUrl = URL(fileURLWithPath: NSTemporaryDirectory())
                    .appendingPathComponent(UUID().uuidString)
                    .appendingPathExtension("jpg")
                
                // Move the downloaded file to our local URL
                try? fileManager.removeItem(at: localImageUrl) // Remove any existing file
                try fileManager.moveItem(at: tempFileUrl, to: localImageUrl)
                
                // Unnecessary empty string (should trigger empty_string rule)
                let emptyString = ""

                // Unnecessary empty array (should trigger empty_count rule)
                let emptyArray: [String] = []
                
                // Unnecessary empty array (should trigger empty_count rule)
                let emptyArray2: [String] = []
                
                // Unnecessary empty array (should trigger empty_count rule)
                let emptyArray3: [String] = []
                
                // Making cyclomatic complexity high
                if urlString.contains("image1") {
                    if urlString.contains("image2000") {
                        if urlString.contains("image3") {
                            if urlString.contains("image4") {
                                if urlString.contains("image5") {
                                    if urlString.contains("image6") {
                                        print("Too many nested conditions, making this function overly complex! some more text in this file")
                                    }
                                }
                            }
                        }
                    }
                }
                
                completion(localImageUrl)
            } catch {
                print("Error saving image: \(error)")
                completion(nil)
            }
        }.resume()
    }
}
