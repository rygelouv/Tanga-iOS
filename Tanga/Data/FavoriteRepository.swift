//
//  FavoriteRepository.swift
//  Tanga
//
//  Created by Rygel Louv on 07/12/2024.
//

import Foundation
import FirebaseFirestore

extension Firestore {
    var favoriteCollection: CollectionReference {
        collection("favorites")
    }
}

class FavoriteRepository {
    let db = Firestore.firestore()
    
    func getFavorites(userId: UserId) async -> Result<[Favorite], Error> {
        let query = db.favoriteCollection.whereField(FirestoreDatabase.Favorites.Fields.USER_ID, isEqualTo: userId)
        
        do {
            let snapshot = try await query.getDocuments()
            let favorites: [Favorite] = try snapshot.documents.compactMap { document in
                try document.data(as: Favorite.self)
            }
            return .success(favorites)
        } catch {
            return .failure(error)
        }
    }
}
