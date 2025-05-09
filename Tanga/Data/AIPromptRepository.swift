import Foundation
import FirebaseFirestore

extension Firestore {
    var promptsCollection: CollectionReference {
        collection("prompts")
    }
}

class AIPromptRepository {
    let db = Firestore.firestore()
    
    func getAIPromptsForSummary(summaryId: String) async -> Result<[AIPrompt], Error> {
        do {
            let documentRef = db.promptsCollection.document(summaryId)
            
            let document = try await documentRef.getDocument()
            let prompts = try document.data(as: AIPrompt.self)
            
            return .success([prompts])
        } catch {
            return .failure(error)
        }
    }
    
    func getAIPrompt(id: String) async throws -> AIPrompt {
        let documentRef = db.promptsCollection.document(id)
        let document = try await documentRef.getDocument()
        
        let prompt = try document.data(as: AIPrompt.self)
        return prompt
    }
} 
