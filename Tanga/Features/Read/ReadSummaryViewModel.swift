//
//  ReadSummaryViewModel.swift
//  Tanga
//
//  Created by Rygel Louv on 03/01/2025.
//

import Foundation
import SwiftUI

@MainActor
class ReadSummaryViewModel: ObservableObject {
    @Published var loading: Bool = true
    @Published var content: String? = nil
    
    private var fileDownloader: TextFileContentDownloader
    
    init(fileDownloader: TextFileContentDownloader) {
        self.fileDownloader = fileDownloader
    }
    
    func fetchContent(summaryId: SummaryId) {
        loading = true
        
        Task {
            do {
                let content = try await fileDownloader.downloadMarkdownFile(summaryId: summaryId)
                DispatchQueue.main.async {
                    self.content = content
                    self.loading = false
                }
            } catch {
                self.loading = false
                //TODO handle error
            }
        }
    }
}
