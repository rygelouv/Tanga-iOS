//
//  CategoryRepository.swift
//  Tanga
//
//  Created by Rygel Louv on 07/10/2024.
//

import Foundation
import FirebaseFirestore

extension Firestore {
    var categoryCollection: CollectionReference {
        collection(FirestoreDatabase.Categories.COLLECTION_NAME)
    }
}

class CategoryRepository {
    let db = Firestore.firestore()
    
    // Function to fetch all categories from Firestore
    func getCategories() async -> Result<[Category], Error> {
        do {
            let snapshot = try await db.categoryCollection.getDocuments()
            
            // Decode the documents into Category models
            let categories: [Category] = try snapshot.documents.compactMap { document in
                try document.data(as: Category.self)
            }
            
            return .success(categories)
        } catch {
            return .failure(error)
        }
    }
    
    func getCategory(id: String) async throws -> Category {
        let documentRef = db.categoryCollection.document(id)
        let document = try await documentRef.getDocument()
        
        let category = try document.data(as: Category.self)
        return category
    }
}
