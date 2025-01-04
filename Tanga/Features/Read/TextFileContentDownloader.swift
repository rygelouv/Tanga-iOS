//
//  TextFileContentDownloader.swift
//  Tanga
//
//  Created by Rygel Louv on 03/01/2025.
//

import Foundation
import FirebaseStorage

extension Storage {
    func summaryReference(summaryId: SummaryId) -> StorageReference {
        reference().child(summaryId)
    }
}

class TextFileContentDownloader {
    private let storage: Storage

    init(storage: Storage = Storage.storage()) {
        self.storage = storage
    }
    
    func downloadMarkdownFile(summaryId: String) async throws -> String {
        let summaryRef = storage.summaryReference(summaryId: summaryId)
        let markdownFileRef = summaryRef.child(SummaryFormatType.text.rawValue)

        return try await withCheckedThrowingContinuation { continuation in
            markdownFileRef.getData(maxSize: Int64(1024 * 1024)) { data, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let data = data, let markdownText = String(data: data, encoding: .utf8) {
                    continuation.resume(returning: markdownText)
                } else {
                    let decodingError = NSError(domain: "FileDownloader", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to decode file content"])
                    continuation.resume(throwing: decodingError)
                }
            }
        }
    }

}
