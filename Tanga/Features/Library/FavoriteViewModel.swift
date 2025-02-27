//
//  FavoriteViewModel.swift
//  Tanga
//
//  Created by Rygel Louv on 09/12/2024.
//

import OSLog
import SwiftUI
import Foundation

/// A ViewModel that handles the logic for managing favorite summaries.
@MainActor
class FavoriteViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published private(set) var isFavorite: Bool = false
    @Published var showAuth: Bool = false
    @Published var error: Error?
    @Published private(set) var isLoading: Bool = false
    
    // MARK: - Private Properties
    private var favorite: Favorite?
    private var summary: Summary?
    private let favoriteRepository: FavoriteRepository
    private let summaryRepository: SummaryRepository
    private let protectedActionInteractor: ProtectedActionInteractor
    
    @AppStorage(sessionIdKey) private var sessionId: String = ""
    
    // MARK: - Error Types
    enum FavoriteError: LocalizedError {
        case failedToSave
        case failedToDelete
        case failedToLoad
        
        var errorDescription: String? {
            switch self {
            case .failedToSave: return "Failed to save favorite"
            case .failedToDelete: return "Failed to delete favorite"
            case .failedToLoad: return "Failed to load favorite status"
            }
        }
    }
    
    // MARK: - Initializer
    init(
        favoriteRepository: FavoriteRepository,
        summaryRepository: SummaryRepository,
        protectedActionInteractor: ProtectedActionInteractor
    ) {
        self.favoriteRepository = favoriteRepository
        self.summaryRepository = summaryRepository
        self.protectedActionInteractor = protectedActionInteractor
    }
    
    // MARK: - Public Methods
    func loadFavoriteStatus(for summaryId: SummaryId) async {
        isLoading = true
        defer { isLoading = false }
        
        // Load both summary and favorite status concurrently
        async let summaryResult = summaryRepository.getSummary(id: summaryId)
        async let favoriteResult = favoriteRepository.getFavoriteForUser(userId: sessionId, summaryId: summaryId)
        
        // Await both results
        do {
            let (summary, favorite) = try await (summaryResult.get(), favoriteResult.get())
            self.summary = summary
            self.favorite = favorite
            self.isFavorite = favorite != nil
        } catch {
            self.error = FavoriteError.failedToLoad
            TangaLogger.shared.error("Failed to load favorite status: \(error.localizedDescription)")
        }
    }
    
    func toggleFavorite() async {
        guard let favorite = favorite ?? summary?.toFavorite(userId: sessionId) else { return }
        
        let action = ProtectedAction.auth(.save)
        let result = await protectedActionInteractor.checkProtectedAction(action)
        
        switch result {
        case .allowed:
            if isFavorite {
                await deleteFavorite(favorite: favorite)
            } else {
                await saveFavorite(favorite: favorite)
            }
        case .authRequired:
            showAuth = true
        case .subscriptionRequired:
            TangaLogger.shared.info("Subscription required for saving favorites")
        }
    }
    
    func dismissAuth() {
        showAuth = false
    }
    
    // MARK: - Private Methods
    private func saveFavorite(favorite: Favorite) async {
        do {
            let favoriteId = try await favoriteRepository.saveFavorite(userId: sessionId, favorite: favorite).get()
            self.isFavorite = true
            self.favorite = favorite
            self.favorite?.id = favoriteId
            AnalyticsTracker.shared.track(event: Events.actionSummarySaved(summaryId: favoriteId))
        } catch {
            self.error = FavoriteError.failedToSave
            TangaLogger.shared.error("Error saving favorite: \(error.localizedDescription)")
        }
    }
    
    private func deleteFavorite(favorite: Favorite) async {
        guard let favoriteId = favorite.id else { return }
        
        do {
            try await favoriteRepository.deleteFavorite(favoriteId: favoriteId).get()
            self.isFavorite = false
            self.favorite = nil
            AnalyticsTracker.shared.track(event: Events.actionSummaryRemoved(summaryId: favoriteId))
        } catch {
            self.error = FavoriteError.failedToDelete
            TangaLogger.shared.error("Error deleting favorite: \(error.localizedDescription)")
        }
    }
}
