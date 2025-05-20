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
    
    func generate(summaryId: SummaryId, audioFormat: AudioFormat) async throws -> URL? {
        let summaryRef = storage.summaryReference(summaryId: summaryId)
        
        // Select the appropriate file reference based on the audio format
        let formatType = audioFormat == .podcast ? SummaryFormatType.podcast : SummaryFormatType.audio
        let fileRef = summaryRef.child(formatType.rawValue)
        
        Logger.audioPlayer.info("Generating URL for format: \(formatType.rawValue)")
        
        return try await withCheckedThrowingContinuation { continuation in
            fileRef.downloadURL() { url, error in
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
