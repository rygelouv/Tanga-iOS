//
//  SearchViewModel.swift
//  Tanga
//
//  Created by Rygel Louv on 18/10/2024.
//

import SwiftUI


class SearchViewModel: ObservableObject {
    var summaryRepository = SummaryRepository()
    var selectedCategories = [CategoryId]()
    
    @Published var summaries: [Summary]?
    
    init(summaries: [Summary]? = nil) {
        self.summaries = summaries
    }
    
    func loadAllSummaries() {
        Task {
            let result = await summaryRepository.getAllSummaries()
            switch result {
            case .success(let summaries):
                DispatchQueue.main.async {
                    self.summaries = summaries
                }
            case .failure:
                self.summaries = nil
            }
        }
    }
    
    func toggleCategorySelection(category: CategoryId) {
        if selectedCategories.contains(category) {
            selectedCategories.removeAll(where: { $0 == category })
        } else {
            selectedCategories.append(category)
        }
        getSummariesForCategories()
    }
    
    func getSummariesForCategories() {
        guard !selectedCategories.isEmpty else {
            loadAllSummaries()
            return
        }
        
        Task {
            var filteredSummaries: [Summary] = []
            for categoryId in selectedCategories {
                let result = await summaryRepository.getSummariesForCategory(categoryId: categoryId)
                switch result {
                case .success(let summaries):
                    filteredSummaries.append(contentsOf: summaries)
                case .failure:
                    print("Error fetching summaries for category \(categoryId)")
                    continue
                }
            }
            DispatchQueue.main.async {
                self.summaries = filteredSummaries.sorted { ($0.title?.lowercased() ?? "") < ($1.title?.lowercased() ?? "") }
            }
        }
    }
}
