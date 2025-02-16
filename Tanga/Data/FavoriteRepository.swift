//
//  FavoriteRepository.swift
//  Tanga
//
//  Created by Rygel Louv on 07/12/2024.
//

import OSLog
import Foundation
import FirebaseFirestore

extension Firestore {
    var favoriteCollection: CollectionReference {
        collection("favorites")
    }
}

protocol FavoriteRepositoryProtocol {
    func getFavorites(userId: UserId) async -> Result<[Favorite], Error>
    func getFavoriteForUser(userId: UserId, summaryId: SummaryId) async -> Result<Favorite?, Error>
    func saveFavorite(userId: UserId, favorite: Favorite) async -> Result<FavoriteId, Error>
    func deleteFavorite(favoriteId: FavoriteId) async -> Result<Void, Error>
}

class FavoriteRepository: FavoriteRepositoryProtocol {
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
    
    func getFavoriteForUser(userId: UserId, summaryId: SummaryId) async -> Result<Favorite?, Error> {
        let query = db.favoriteCollection.whereField(FirestoreDatabase.Favorites.Fields.USER_ID, isEqualTo: userId)
            .whereField(FirestoreDatabase.Favorites.Fields.SUMMARY_ID, isEqualTo: summaryId)
        
        do {
            let snapshot = try await query.getDocuments()
            let favorite: Favorite? = snapshot.documents.isEmpty ? nil : try snapshot.documents.first?.data(as: Favorite.self)
            return .success(favorite)
        } catch {
            return .failure(error)
        }
    }
    
    func saveFavorite(userId: UserId, favorite: Favorite) async -> Result<FavoriteId, Error> {
        do {
            let document = db.favoriteCollection.document()
            // If a favorite is missing one of its fields then error should be thrown. This is why we are force-casting from Any? to Any
            try document.setData(from: favorite)
            let favoriteId = FavoriteId(document.documentID)
            Logger.data.info("Favorite in Repo ID ==> \(favoriteId)")
            return .success(favoriteId)
        } catch {
            return .failure(error)
        }
    }
    
    func deleteFavorite(favoriteId: FavoriteId) async -> Result<Void, Error> {
        do {
            let document = db.favoriteCollection.document(favoriteId)
            try await document.delete()
            return .success(())
        } catch {
            return .failure(error)
        }
    }
}
