//
//  UserDataMapper.swift
//  Tanga
//
//  Created by Rygel Louv on 20/10/2024.
//

extension FirebaseUser {
    func toUser() -> User {
        return User(
            id: self.uid,
            fullName: self.displayName ?? "",
            email: self.email ?? "",
            photoUrl: self.photoURL?.absoluteString,
            createdAt: self.metadata.creationDate
        )
    }
}
