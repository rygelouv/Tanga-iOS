import SwiftUI

struct AIPromptsView: View {
    @StateObject private var viewModel: AIPromptsViewModel
    let summaryId: String
    
    init(summaryId: String) {
        self.summaryId = summaryId
        // Create the ViewModel on the main actor
        let viewModel = AIPromptsViewModel()
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(viewModel.state.prompts) { prompt in
                    PromptButton(prompt: prompt)
                }
            }
            .padding()
        }
        .task {
            viewModel.getAIPromptsForSummary(summaryId: summaryId)
        }
    }
}

struct PromptButton: View {
    let prompt: AIPromptUI
    
    var body: some View {
        Button(action: {
            // Handle prompt selection
        }) {
            HStack {
                Image(systemName: prompt.icon)
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(width: 24)
                
                Text(prompt.title)
                    .font(.body)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .cornerRadius(8)
        }
    }
}

#Preview {
    AIPromptsView(summaryId: "test")
} 