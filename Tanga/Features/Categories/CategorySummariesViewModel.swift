//
//  CategoriesViewModel.swift
//  Tanga
//
//  Created by Rygel Louv on 11/10/2024.
//
import SwiftUI

class CategorySummariesViewModel: ObservableObject {
    var summaryRepository = SummaryRepository()
    var categoryId: CategoryId
    
    @Published var summaries: [Summary]?
    @Published var category: PredefinedCategory?
    @Published var isLoading: Bool = false
    @Published var error: Error?
    
    init(categoryId: CategoryId) {
        self.categoryId = categoryId
    }
    
    func load() {
        self.isLoading = true
        Task {
            let result = await summaryRepository.getSummariesForCategory(categoryId: categoryId)
            switch result {
            case .success(let summaries):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.summaries = summaries
                    self.category = .fromId(self.categoryId)
                }
            case .failure (let error):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.error = error
                }
            }
        }
    }
}
