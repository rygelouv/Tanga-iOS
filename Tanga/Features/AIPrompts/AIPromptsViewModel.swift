import Foundation
import OSLog

@MainActor
class AIPromptsViewModel: ObservableObject {
    private let repository: AIPromptRepository
    private let logger = Logger(subsystem: "com.tanga", category: "AIPromptsViewModel")
    
    @Published private(set) var state = State()
    
    struct State {
        var summaryId: String = ""
        var prompts: [AIPromptUI] = []
        var isLoading: Bool = false
        var error: Error? = nil
    }
    
    init(repository: AIPromptRepository = AIPromptRepository()) {
        self.repository = repository
    }
    
    func getAIPromptsForSummary(summaryId: String) {
        state.isLoading = true
        state.summaryId = summaryId
        
        Task {
            let result = await repository.getAIPromptsForSummary(summaryId: "designing_your_life")
            
            switch result {
            case .success(let prompts):
                logger.info("Successfully fetched AI prompts: \(prompts.count)")
                state.prompts = prompts.map { $0.toUI() }
                state.error = nil
            case .failure(let error):
                logger.error("Error fetching AI prompts: \(error.localizedDescription)")
                state.error = error
            }
            
            state.isLoading = false
        }
    }
} 
