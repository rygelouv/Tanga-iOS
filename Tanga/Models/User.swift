//
//  User.swift
//  Tanga
//
//  Created by Rygel Louv on 20/10/2024.
//

import Foundation
import FirebaseFirestore

typealias UserId = String

// Conforming User to Identifiable and Codable
struct User: Identifiable, Codable {
    @DocumentID  var id: UserId? // id should not be nullable but for some reason when made non-nullable, it bring a bunch of compile issues. Need to investigate later.
    let fullName: String
    let email: String
    let photoUrl: String?
    let isAnonymous: Bool
    let createdAt: Date?
    let subscribedAt: Date?
    
    // Computed property for firstName
    var firstName: String {
        return fullName.split(separator: " ").first.map(String.init) ?? fullName
    }

    // Initializer with default values
    init(id: UserId, fullName: String, email: String, photoUrl: String? = nil, isAnonymous: Bool = false, createdAt: Date? = nil, subscribedAt: Date? = nil) {
        self.id = id
        self.fullName = fullName
        self.email = email
        self.photoUrl = photoUrl
        self.isAnonymous = isAnonymous
        self.createdAt = createdAt
        self.subscribedAt = subscribedAt
    }
}
