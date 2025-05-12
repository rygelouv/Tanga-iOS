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
        logger.debug("Fetching rich insights for summary ID: \(summaryId)")
        
        // Direct access to the document using summaryId as the document ID
        let documentRef = db.richInsightsCollection.document(summaryId)
        
        do {
            let document = try await documentRef.getDocument()
            
            if !document.exists {
                logger.warning("No rich insights document found for summary ID: \(summaryId)")
                return .success([]) // Return empty array if document doesn't exist
            }
            
            logger.debug("Retrieved document ID: \(document.documentID)")
            
            // Extract the insights array from the document
            guard let insightsData = document.data()?[FirestoreDatabase.RichInsights.Fields.INSIGHTS] as? [[String: Any]] else {
                logger.error("No insights array found in document or invalid format")
                return .success([]) // Return empty array if insights field is missing or invalid
            }
            
            logger.debug("Found \(insightsData.count) insights in the document")
            logger.debug("Insights Data =======> \(insightsData)")
            
            // Convert each dictionary in the array to a RichInsight object
            var richInsights: [RichInsight] = []
            
            for (index, insightDict) in insightsData.enumerated() {
                do {
                    logger.debug("Insights  =======> \(insightDict)")
                    // Convert dictionary to data
                    let data = try JSONSerialization.data(withJSONObject: insightDict)
                    logger.debug("data ===> \(data)")
                    
                    // Decode data to RichInsight
                    let insight = try JSONDecoder().decode(RichInsight.self, from: data)
                    richInsights.append(insight)
                    logger.debug("Successfully parsed insight \(index + 1)")
                } catch {
                    logger.error("Failed to parse insight at index \(index): \(error.localizedDescription)")
                    // Continue with the next insight
                }
            }
            
            logger.debug("Successfully parsed \(richInsights.count) rich insights")
            
            // Sort insights by their number field
            let sortedInsights = richInsights.sorted { $0.number < $1.number }
            logger.debug("Sorted insights by number: \(sortedInsights.map { $0.number })")
            
            return .success(sortedInsights)
        } catch {
            logger.error("Failed to fetch rich insights: \(error.localizedDescription)")
            return .failure(error)
        }
    }
}
