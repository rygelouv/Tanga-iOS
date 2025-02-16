//
//  FavoriteViewModel.swift
//  Tanga
//
//  Created by Rygel Louv on 07/12/2024.
//

import OSLog
import SwiftUI

class LibraryViewModel: ObservableObject {
    var favoriteRepository: FavoriteRepositoryProtocol
    
    @Published var favorites: [Favorite]?
    
    // Get the user id from app storage
    @AppStorage(sessionIdKey) var sessionId: String = ""
    
    init(favoriteRepository: FavoriteRepositoryProtocol) {
        self.favoriteRepository = favoriteRepository
    }
    
    @MainActor
    func loadFavorites() async {
        let result = await favoriteRepository.getFavorites(userId: sessionId)
        switch result {
        case .success(let favorites):
            self.favorites = favorites
        case .failure(let error):
            Logger.library.error("Error loading favorites: \(error)")
        }
    }
}

