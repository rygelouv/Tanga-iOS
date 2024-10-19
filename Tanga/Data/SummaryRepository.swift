//
//  SummaryRepository.swift
//  Tanga
//
//  Created by Rygel Louv on 07/10/2024.
//

import Foundation
import FirebaseFirestore


extension Firestore {
    var summaryCollection: CollectionReference {
        collection(FirestoreDatabase.Summaries.COLLECTION_NAME)
    }
    
    var weeklySummaryCollection: CollectionReference {
        return collection(FirestoreDatabase.WeeklySummary.COLLECTION_NAME)
    }
}

class SummaryRepository {
    let db = Firestore.firestore()
    
    /*
     * Unused for now until we see if there is a real performance problem with UI side search filetering
     */
    func searchSummaries(query: String, selectedCategories: [CategoryId]) async -> Result<[Summary], Error> {
        let query = db.summaryCollection
            .whereField(FirestoreDatabase.Summaries.Fields.IS_VISIBLE, isEqualTo: true)
            .whereField(FirestoreDatabase.Summaries.Fields.TITLE, arrayContains: query)
            .whereField(FirestoreDatabase.Summaries.Fields.AUTHOR, arrayContains: query)
            .whereField( FirestoreDatabase.Summaries.Fields.CATEGORIES, arrayContainsAny: selectedCategories)
        
        do {
            let snapshot = try await query.getDocuments()
            let summaries: [Summary] = try snapshot.documents.compactMap { document in
                try document.data(as: Summary.self)
            }
            return .success(summaries)
        } catch {
            return .failure(error)
        }
    }
    
    func getSummariesForCategory(categoryId: CategoryId) async -> Result<[Summary], Error> {
        let query = db.summaryCollection
            .whereField(FirestoreDatabase.Summaries.Fields.IS_VISIBLE, isEqualTo: true)
            .whereField( FirestoreDatabase.Summaries.Fields.CATEGORIES, arrayContains: categoryId)

        do {
            let snapshot = try await query.getDocuments()
            let summaries: [Summary] = try snapshot.documents.compactMap { document in
                try document.data(as: Summary.self)
            }
            return .success(summaries)
        } catch {
            return .failure(error)
        }
    }
    
    // Function to get a summary by its ID
    func getSummary(id: SummaryId) async -> Result<Summary, Error> {
        let documentRef = db.summaryCollection.document(id)
        
        do {
            let document = try await documentRef.getDocument()
            if document.exists {
                let summary = try document.data(as: Summary.self)
                return .success(summary)
            } else {
                // Document doesn't exist
                return .failure(NSError(domain: "SummariesRepository", code: 404, userInfo: [NSLocalizedDescriptionKey: "Summary not found"]))
            }
        } catch {
            return .failure(error)
        }
    }
    
    // Function to get all summaries that are visible (isVisible == true)
    func getAllSummaries() async -> Result<[Summary], Error> {
        let query = db.summaryCollection.whereField(FirestoreDatabase.Summaries.Fields.IS_VISIBLE, isEqualTo: true)
        
        do {
            let snapshot = try await query.getDocuments()
            let summaries: [Summary] = try snapshot.documents.compactMap { document in
                try document.data(as: Summary.self)
            }
            return .success(summaries)
        } catch {
            return .failure(error)
        }
    }
    
    // Function to get the first weekly summary document and fetch the corresponding summary by ID
    func getWeeklySummary() async -> Result<Summary, Error> {
        do {
            // Get the first document in the weeklySummary collection
            let snapshot = try await db.weeklySummaryCollection.limit(to: 1).getDocuments()
            
            // Check if there is at least one document
            if let document = snapshot.documents.first {
                let summaryId = document.documentID
                // Call getSummaryById to fetch the full Summary by its ID
                return await getSummary(id: summaryId)
            } else {
                // Return a custom error if no weekly summary is found
                return .failure(NSError(domain: "SummariesRepository", code: 404, userInfo: [NSLocalizedDescriptionKey: "No weekly summary found"]))
            }
        } catch {
            // Handle Firestore or decoding errors
            return .failure(error)
        }
     }
}
