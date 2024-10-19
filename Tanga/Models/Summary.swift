//
//  Summary.swift
//  Tanga
//
//  Created by Rygel Louv on 07/10/2024.
//

import Foundation
import FirebaseFirestore

// Define types for SummaryId and CategoryId
typealias SummaryId = String

// Class representing a Summary
struct Summary: Identifiable, Codable {
    @DocumentID var id: SummaryId?
    var title: String?
    var author: String?
    var synopsis: String?
    var coverImageUrl: String?
    var playingLength: String?
    var purchaseBookUrl: String?
    var categories: [CategoryId]?
}
