//
//  FavoriteViewModel.swift
//  Tanga
//
//  Created by Rygel Louv on 09/12/2024.
//

import SwiftUI
import Foundation

/// A ViewModel that handles the logic for managing favorite summaries.
///
/// This class is annotated with `@MainActor` to ensure all state modifications
/// are performed on the main thread, making it safe for use in UI updates.
@MainActor
class FavoriteViewModel: ObservableObject {
    /// Indicates whether the current summary is marked as a favorite.
    @Published var isFavorite: Bool = false
    
    /// The current favorite object associated with the summary.
    private var favorite: Favorite?
    
    /// The summary object being managed.
    private var summary: Summary?
    
    private var favoriteRepository: FavoriteRepository
    private var summaryRepository: SummaryRepository
    
    /// The user's session ID, used to identify the current user.
    @AppStorage(sessionIdKey) var sessionId: String = ""
    
    // MARK: - Initializer

    /// Initializes the `FavoriteViewModel` with the required repositories.
    ///
    /// - Parameters:
    ///   - favoriteRepository: A repository for managing favorite data.
    ///   - summaryRepository: A repository for fetching summary data.
    init(favoriteRepository: FavoriteRepository, summaryRepository: SummaryRepository) {
        self.favoriteRepository = favoriteRepository
        self.summaryRepository = summaryRepository
    }
    
    // MARK: - Public Methods

    /// Retrieves the favorite status for a given summary ID and updates the `isFavorite` state.
    ///
    /// - Parameter summaryId: The ID of the summary to check.
    func getFavorite(summaryId: SummaryId) {
        Task {
            let result = await favoriteRepository.getFavoriteForUser(userId: sessionId, summaryId: summaryId)
            switch result {
            case .success(let favorite):
                self.favorite = favorite
                let isFavorite = favorite != nil
                DispatchQueue.main.async {
                    self.isFavorite = isFavorite
                }
            case .failure:
                self.favorite = nil
            }
        }
        loadSummary(summaryId: summaryId)
    }
    
    func loadSummary(summaryId: SummaryId) {
        Task {
            let result = await summaryRepository.getSummary(id: summaryId)
            switch result {
            case .success(let summary):
                self.summary = summary
            case .failure:
                self.summary = nil
            }
        }
    }
    
    /// Toggles the favorite status for the current summary.
    ///
    /// If the summary is already a favorite, it is removed. Otherwise, it is added to the favorites.
    func toggleFavorite() {
        guard let favorite = favorite ?? summary?.toFavorite(userId: sessionId) else { return }
        print("favorite ===> \(favorite)")
        
        if isFavorite {
            deleteFavorite(favorite: favorite)
        } else {
            saveFavorite(favorite: favorite)
        }
    }
    
    // MARK: - Private Methods

    /// Saves the given favorite to the repository and updates the state.
    ///
    /// - Parameter favorite: The favorite object to save.
    private func saveFavorite(favorite: Favorite) {
        Task {
            let result = await favoriteRepository.saveFavorite(userId: sessionId, favorite: favorite)
            switch result {
            case .success (let favoriteId):
                DispatchQueue.main.async {
                    self.isFavorite = true
                    self.favorite = favorite
                    self.favorite?.id = favoriteId
                }
            case .failure:
                print("Error saving favorite")
            }
        }
    }
    
    private func deleteFavorite(favorite: Favorite) {
        Task {
            guard let favoriteId = favorite.id else { return }
            let result = await favoriteRepository.deleteFavorite(favoriteId: favoriteId)
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.isFavorite = false
                }
            case .failure:
                print("Error deleting favorite")
            }
        }
    }
}
