//
//  RichInsightsRepository.swift
//  Tanga
//
//  Created on 12/05/2025.
//

import Foundation
import FirebaseFirestore
import OSLog

extension Firestore {
    var richInsightsCollection: CollectionReference {
        collection(FirestoreDatabase.RichInsights.COLLECTION_NAME)
    }
}

class RichInsightsRepository {
    let db = Firestore.firestore()
    private let logger = Logger(subsystem: "com.tanga", category: "RichInsightsRepository")
    
    /// Fetches all rich insights for a specific summary
    /// - Parameter summaryId: The ID (slug) of the summary to fetch insights for
    /// - Returns: A Result containing either an array of RichInsight objects or an Error
    func getRichInsightsForSummary(summaryId: String) async -> Result<[RichInsight], Error> {
        // Direct access to the document using summaryId as the document ID
        let documentRef = db.richInsightsCollection.document(summaryId)
        
        do {
            let document = try await documentRef.getDocument()
            
            if !document.exists {
                logger.warning("No rich insights document found for summary ID: \(summaryId)")
                return .success([]) // Return empty array if document doesn't exist
            }
            
            // Extract the insights array from the document
            guard let insightsData = document.data()?[FirestoreDatabase.RichInsights.Fields.INSIGHTS] as? [[String: Any]] else {
                logger.error("No insights array found in document or invalid format")
                return .success([]) // Return empty array if insights field is missing or invalid
            }
            
            // Convert each dictionary in the array to a RichInsight object
            var richInsights: [RichInsight] = []
            
            for (index, insightDict) in insightsData.enumerated() {
                do {
                    // Convert dictionary to data
                    let data = try JSONSerialization.data(withJSONObject: insightDict)
                    
                    // Decode data to RichInsight
                    let insight = try JSONDecoder().decode(RichInsight.self, from: data)
                    richInsights.append(insight)
                } catch {
                    logger.error("Failed to parse insight at index \(index): \(error.localizedDescription)")
                    // Continue with the next insight
                }
            }
            
            // Sort insights by their number field
            let sortedInsights = richInsights.sorted { $0.number < $1.number }
            
            return .success(sortedInsights)
        } catch {
            logger.error("Failed to fetch rich insights: \(error.localizedDescription)")
            return .failure(error)
        }
    }
}
