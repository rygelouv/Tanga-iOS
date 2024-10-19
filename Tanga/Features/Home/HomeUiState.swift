//
//  HomeUiState.swift
//  Tanga
//
//  Created by Rygel Louv on 07/10/2024.
//

struct HomeUiState {
    var isLoading: Bool
    var userFirstName: String? = "Anonymous"
    var userPhotoUrl: String? = "https://placeholder.com/200x200"
    var weeklySummary: WeeklySummaryModel?
    var sections: [Section]?
    var error: Error?
}

struct WeeklySummaryModel {
    var category: Category
    var summary: Summary
}
