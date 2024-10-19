//
//  HomeViewModel.swift
//  Tanga
//
//  Created by Rygel Louv on 07/10/2024.
//

import SwiftUI

@MainActor
class HomeViewModel: ObservableObject {
    @Published var uiState: HomeUiState
    
    private let summaryReposiory = SummaryRepository()
    private let categoryRepository = CategoryRepository()
    
    // we don't actually need to pass in the state. We are doing this here to make the previews work
    init(uiState: HomeUiState? = nil) {
        self.uiState = uiState ?? HomeUiState(isLoading: true)
    }
    
    func loadHomeData() {
        Task {
            do {
                let weeklySummary = await summaryReposiory.getWeeklySummary()
                switch weeklySummary {
                case .success(let summary):
                    let category = try await categoryRepository.getCategory(id: summary.categories?.first ?? "unknown")
                    let weeklySummary = WeeklySummaryModel(category: category, summary: summary)
                    DispatchQueue.main.async {
                        self.uiState.weeklySummary = weeklySummary
                        print("Successfully loaded weekly summary \(weeklySummary)")
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.uiState.error = error
                    }
                }
                
                try await self.fetchSections()
                DispatchQueue.main.async {
                    self.uiState.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.uiState.error = error
                    self.uiState.isLoading = false
                }
            }
        }
    }
    
    private func fetchSections() async throws {
        let summaries = await summaryReposiory.getAllSummaries()
        
        switch summaries {
        case .success(let summaries):
            let categories = await categoryRepository.getCategories()
            
            switch categories {
            case .success(let categories):
                var sections = [Section]()
                for category in categories {
                    let summariesForCategory = summaries.filter { summary in
                        return summary.categories?.contains(category.slug!) == true
                    }.prefix(5)
                    
                    let section = Section(category: category, summaries: Array(summariesForCategory))
                    sections.append(section)
                }
                DispatchQueue.main.async {
                    self.uiState.sections = sections
                }
            case .failure(let error):
                throw error
            }
        case .failure(let error):
            throw error
        }
    }
}
