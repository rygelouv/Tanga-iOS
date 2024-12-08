//
//  FavoriteViewModel.swift
//  Tanga
//
//  Created by Rygel Louv on 07/12/2024.
//

import SwiftUI

class LibraryViewModel: ObservableObject {
    var favoriteRepository: FavoriteRepository
    
    @Published var favorites: [Favorite]?
    
    // Get the user id from app storage
    @AppStorage(sessionIdKey) var sessionId: String = ""
    
    init(favoriteRepository: FavoriteRepository) {
        self.favoriteRepository = favoriteRepository
    }
    
    func loadFavorites() {
        Task {
            let result = await favoriteRepository.getFavorites(userId: sessionId)
            switch result {
                case .success(let favorites):
                DispatchQueue.main.async {
                    self.favorites = favorites
                }
            case .failure(let error):
                print("Error loading favorites: \(error)")
            }
        }
    }
}

