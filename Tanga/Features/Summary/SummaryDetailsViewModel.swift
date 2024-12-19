//
//  SummaryDetailsViewModel.swift
//  Tanga
//
//  Created by Rygel Louv on 09/12/2024.
//

import SwiftUI

@MainActor
class SummaryDetailsViewModel: ObservableObject {
    @Published var summary: Summary?
    @Published var recommendations: [Summary]?
    
    private var summaryRepository: SummaryRepository
    
    init(summaryRepository: SummaryRepository) {
        self.summaryRepository = summaryRepository
    }
    
    func loadDetails(summaryId: SummaryId) {
        Task {
            let result = await summaryRepository.getSummary(id: summaryId)
            switch result {
            case .success(let summary):
                DispatchQueue.main.async {
                    self.summary = summary
                }
                loadRecommendation(summary: summary)
            case .failure(let error):
                print("Failed to load summary details: \(error)")
            }
        }
    }
    
    func loadRecommendation(summary: Summary) {
        Task {
            let result = await summaryRepository.getRecommendationsForSummary(summary: summary)
            switch result {
            case .success(let recommendations):
                DispatchQueue.main.async {
                    self.recommendations = recommendations
                }
            case .failure(let error):
                print("Failed to load recommendations: \(error)")
            }
        }
    }
}
