import Foundation
import SwiftUI
import OSLog

// ViewModel for Rich Insights feature
@MainActor
class RichInsightsViewModel: ObservableObject {
    private let repository: RichInsightsRepository
    private let logger = Logger(subsystem: "com.tanga", category: "RichInsightsViewModel")
    private let summaryId: String
    private let bookCoverUrl: String

    
    // Published state elements
    @Published private(set) var isLoading = false
    @Published private(set) var pages: [any InsightPage] = []
    @Published private(set) var error: Error? = nil
    
    init(summaryId: String, bookCoverUrl: String, repository: RichInsightsRepository = RichInsightsRepository()) {
        self.summaryId = summaryId
        self.bookCoverUrl = bookCoverUrl
        self.repository = repository
    }
    
    // Load rich insights for the specified summary
    func loadRichInsights() async {
        if isLoading { return }
        
        isLoading = true
        error = nil
        
        let result = await repository.getRichInsightsForSummary(summaryId: summaryId)
        
        switch result {
        case .success(let richInsights):
            // Convert domain models to UI models in correct sequence
            pages = transformToPages(richInsights)
            isLoading = false
            
        case .failure(let error):
            logger.error("Failed to load rich insights: \(error.localizedDescription)")
            self.error = error
            isLoading = false
        }
    }
    
    // Transform domain models into UI models in the correct sequence
    private func transformToPages(_ richInsights: [RichInsight]) -> [any InsightPage] {
        var pages: [any InsightPage] = []
        
        // For each insight, create an idea page followed by a video page
        for insight in richInsights {
            // Create and add idea page
            let ideaPage = IdeaPageInsightUI(from: insight, bookCoverUrl: bookCoverUrl)
            pages.append(ideaPage)
            
            // Create and add video page
            let videoPage = VideoPageInsightUI(from: insight)
            pages.append(videoPage)
        }
        
        // Add the end page as the last page
        if !richInsights.isEmpty {
            // Use the last insight number + 1 for the end page number
            let endPageNumber = (richInsights.last?.number ?? 0) + 1
            let endPage = EndPageInsightUI(number: endPageNumber)
            pages.append(endPage)
        }
        
        return pages
    }
    
    // Helper to get a specific page by index - with type casting helpers
    func ideaPage(at index: Int) -> IdeaPageInsightUI? {
        guard index >= 0 && index < pages.count else { return nil }
        return pages[index] as? IdeaPageInsightUI
    }
    
    func videoPage(at index: Int) -> VideoPageInsightUI? {
        guard index >= 0 && index < pages.count else { return nil }
        return pages[index] as? VideoPageInsightUI
    }
    
    func endPage(at index: Int) -> EndPageInsightUI? {
        guard index >= 0 && index < pages.count else { return nil }
        return pages[index] as? EndPageInsightUI
    }
    
    // Generic page getter
    func page(at index: Int) -> (any InsightPage)? {
        guard index >= 0 && index < pages.count else { return nil }
        return pages[index]
    }
    
    // Total number of pages
    var pageCount: Int {
        return pages.count
    }
    
    // Check if we have pages
    var hasPages: Bool {
        return !pages.isEmpty
    }
}
