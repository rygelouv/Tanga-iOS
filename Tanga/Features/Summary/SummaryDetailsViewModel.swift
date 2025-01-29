//
//  SummaryDetailsViewModel.swift
//  Tanga
//
//  Created by Rygel Louv on 09/12/2024.
//

import OSLog
import SwiftUI

@MainActor
class SummaryDetailsViewModel: ObservableObject {
    @Published var summary: Summary?
    @Published var recommendations: [Summary]?
    
    private var summaryRepository: SummaryRepository
    
    init(summaryRepository: SummaryRepository) {
        self.summaryRepository = summaryRepository
    }
    
    @MainActor
    func loadDetails(summaryId: SummaryId) async {
        let result = await summaryRepository.getSummary(id: summaryId)
        switch result {
        case .success(let summary):
            self.summary = summary
            await loadRecommendation(summary: summary)
        case .failure(let error):
            Logger.summary.error("Failed to load summary details: \(error)")
        }
    }
    
    @MainActor
    private func loadRecommendation(summary: Summary) async {
        let result = await summaryRepository.getRecommendationsForSummary(summary: summary)
        switch result {
        case .success(let recommendations):
            self.recommendations = recommendations
        case .failure(let error):
            Logger.summary.error("Failed to load recommendations: \(error)")
        }
    }
}
