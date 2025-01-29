//
//  DownloadUrlGenerator.swift
//  Tanga
//
//  Created by Rygel Louv on 04/01/2025.
//

import OSLog
import Foundation
import FirebaseStorage

class DownloadUrlGenerator {
    private let storage: Storage
    
    init(storage: Storage) {
        self.storage = storage
    }
    
    func generate(summaryId: SummaryId) async throws -> URL? {
        let summaryRef = storage.summaryReference(summaryId: summaryId)
        let audioFileRef = summaryRef.child(SummaryFormatType.audio.rawValue)
        
        return try await withCheckedThrowingContinuation { continuation in
            audioFileRef.downloadURL() { url, error in
                if let error {
                    Logger.audioPlayer.error("Error downloading file: \(error)")
                    continuation.resume(throwing: error)
                } else {
                    Logger.audioPlayer.info("URL generated successfully: \(url?.absoluteString ?? "")")
                    continuation.resume(returning: url)
                }
            }
        }
    }
}
