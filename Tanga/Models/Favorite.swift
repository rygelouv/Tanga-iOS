//
//  Favorite.swift
//  Tanga
//
//  Created by Rygel Louv on 07/12/2024.
//

import Foundation
import FirebaseFirestore


// Define types for SummaryId and CategoryId
typealias FavoriteId = String

// Class representing a Summary
struct Favorite: Identifiable, Codable {
    @DocumentID var id: FavoriteId?
    var title: String?
    var author: String?
    var coverUrl: String?
    var playingLength: String?
    var summaryId: SummaryId?
    var userId: UserId?
}

extension Favorite {
   func toSummary() -> Summary {
       Summary(
           id: summaryId,
           title: title,
           author: author,
           synopsis: nil,
           coverImageUrl: coverUrl,
           playingLength: playingLength,
           purchaseBookUrl: nil,
           categories: nil
       )
   }
}

extension Summary {
   func toFavorite(userId: UserId) -> Favorite {
       Favorite(
           title: title,
           author: author,
           coverUrl: coverImageUrl,
           playingLength: playingLength,
           summaryId: id,
           userId: userId
       )
   }
}
