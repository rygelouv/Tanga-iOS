import Foundation
import FirebaseFirestore

struct AIPrompt: Identifiable, Codable {
    @DocumentID var id: String?
    let title: String
    let description: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description = "promptDescription"
    }
}

// UI representation with icon binding
struct AIPromptUI: Identifiable {
    let id: String
    let icon: String  // We'll use SF Symbols instead of drawable resources
    let title: String
    let description: String
}

// Predefined prompts enum
enum PredefinedAIPrompts: String {
    case keyTakeaways = "prompt_key_takeaways"
    case applyLessonsInLife = "prompt_apply_lessons_in_life"
    case quotesFromBook = "prompt_quotes_from_book"
    
    var icon: String {
        switch self {
        case .keyTakeaways:
            return "key"
        case .applyLessonsInLife:
            return "book"
        case .quotesFromBook:
            return "quote"
        }
    }
    
    static func fromId(_ id: String) -> PredefinedAIPrompts? {
        return PredefinedAIPrompts(rawValue: id)
    }
}

// Extension to convert AIPrompt to AIPromptUI
extension AIPrompt {
    func toUI() -> AIPromptUI {
        let predefinedPrompt = PredefinedAIPrompts.fromId(id ?? "")
        return AIPromptUI(
            id: id ?? "",
            icon: predefinedPrompt?.icon ?? "idea",
            title: title,
            description: description
        )
    }
} 
