//
//  DownloadUrlGenerator.swift
//  Tanga
//
//  Created by Rygel Louv on 04/01/2025.
//

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
                    print("Error downloading file: \(error)")
                    continuation.resume(throwing: error)
                } else {
                    print("URL generated successfully: \(url?.absoluteString ?? "")")
                    continuation.resume(returning: url)
                }
            }
        }
    }
}
