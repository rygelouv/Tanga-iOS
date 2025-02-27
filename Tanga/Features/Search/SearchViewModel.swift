//
//  SearchViewModel.swift
//  Tanga
//
//  Created by Rygel Louv on 18/10/2024.
//

import OSLog
import SwiftUI

class SearchViewModel: ObservableObject {
    var summaryRepository = SummaryRepository()
    var selectedCategories = [CategoryId]()
    
    @Published var summaries: [Summary]?
    
    init(summaries: [Summary]? = nil) {
        self.summaries = summaries
    }
    
    @MainActor
    func loadAllSummaries() async {
        let result = await summaryRepository.getAllSummaries()
        self.summaries = try? result.get()
    }
    
    func toggleCategorySelection(category: CategoryId) async {
        if selectedCategories.contains(category) {
            selectedCategories.removeAll(where: { $0 == category })
        } else {
            selectedCategories.append(category)
        }
        await getSummariesForCategories()
    }
   
    @MainActor
    func getSummariesForCategories() async {
        guard !selectedCategories.isEmpty else {
            await loadAllSummaries()
            return
        }
        
        let filteredSummaries = await fetchSummariesConcurrently()
        self.summaries = filteredSummaries.sorted { ($0.title?.lowercased() ?? "") < ($1.title?.lowercased() ?? "") }
    }
    
    private func fetchSummariesConcurrently() async -> [Summary] {
        await withTaskGroup(of: [Summary].self) { group in
            var allSummaries = [Summary]()
            allSummaries.reserveCapacity(selectedCategories.count)
            
            for categoryId in selectedCategories {
                group.addTask {
                    let result = await self.summaryRepository.getSummariesForCategory(categoryId: categoryId)
                    switch result {
                    case .success(let summaries):
                        return summaries
                    case .failure:
                        TangaLogger.shared.error("Error fetching summaries for category \(categoryId)")
                        return []
                    }
                }
            }
            
            for await summaries in group {
                allSummaries.append(contentsOf: summaries)
            }
            return allSummaries
        }
    }
}
