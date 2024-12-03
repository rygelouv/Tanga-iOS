//
//  UserRepository.swift
//  Tanga
//
//  Created by Rygel Louv on 20/10/2024.
//

import Foundation
import FirebaseFirestore


class UserRepository {
    private let db = Firestore.firestore()
    
    // Firestore collection reference for users
    private var usersCollection: CollectionReference {
        return db.collection(FirestoreDatabase.Users.COLLECTION_NAME)
    }
    
    // Get a single user by ID
    func getUser(byId userId: UserId) async -> Result<User, Error> {
        let documentRef =  usersCollection.document(userId)
        do {
            let document = try await documentRef.getDocument()
            if document.exists {
                let user = try document.data(as: User.self)
                return .success(user)
            } else {
                return .failure(NSError(domain: "UserRepository", code: 404, userInfo: [NSLocalizedDescriptionKey: "User not found"]))
            }
        } catch {
            return .failure(error)
        }
    }
    
    // Get a single user by ID using AsyncSequence for real-time updates
    func getUserStream(byId userId: UserId) -> AsyncThrowingStream<User, Error> {
        AsyncThrowingStream { continuation in
            let listener = usersCollection.document(userId).addSnapshotListener { documentSnapshot, error in
                if let error = error {
                    continuation.finish(throwing: error) // If an error occurs, finish with error
                    return
                }
                
                do {
                    let user = try documentSnapshot?.data(as: User.self)
                    if let user {
                        continuation.yield(user) // Yield the user to the async sequence
                    } else {
                        let notFoundError = NSError(domain: "UserRepository", code: 404, userInfo: [NSLocalizedDescriptionKey: "User not found"])
                        continuation.finish(throwing: notFoundError) // Finish with error if user not found
                    }
                } catch {
                    continuation.finish(throwing: error) // Finish with error if decoding fails
                }
            }
            
            // Handle the task cancellation to remove the Firestore listener
            continuation.onTermination = { @Sendable _ in
                listener.remove()
            }
        }
    }
    
    // Create a new user in Firestore
    func createUser(user: User) async -> Result<User, Error> {
        do {
            let document = usersCollection.document(user.id ?? UUID().uuidString) // Using UUID if id is nil
            try document.setData(from: user)
            return .success(user)
        } catch {
            return .failure(error)
        }
    }
    
    // Update an existing user
    func updateUser(user: User) async -> Result<User, Error> {
        guard let userId = user.id else {
            return .failure(NSError(domain: "UserRepository", code: 400, userInfo: [NSLocalizedDescriptionKey: "User ID is missing"]))
        }
        
        do {
            try usersCollection.document(userId).setData(from: user, merge: true)
            return .success(user)
        } catch {
            return .failure(error)
        }
    }
    
    // Delete a user from Firestore
    func deleteUser(user: User) async -> Result<Void, Error> {
        guard let userId = user.id else {
            return .failure(NSError(domain: "UserRepository", code: 400, userInfo: [NSLocalizedDescriptionKey: "User ID is missing"]))
        }
        
        do {
            try await usersCollection.document(userId).delete()
            return .success(())
        } catch {
            return .failure(error)
        }
    }
}
