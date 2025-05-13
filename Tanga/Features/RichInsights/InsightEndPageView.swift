import SwiftUI

struct InsightEndPageView: View {
    let viewModel: EndPageInsightUI
    
    var body: some View {
        ZStack {
            // Background
            Color(hex: "11487A")
                .ignoresSafeArea()
            
            // Content
            VStack(spacing: 24) {
                Spacer()
                
                // Header
                VStack(spacing: 16) {
                    Text("You've Reached the End of Insights")
                        .font(Font.custom("Montserrat", size: 22, relativeTo: .title2))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Text("Want to learn more about this book? Choose an option below to continue your learning journey.")
                        .font(Font.custom("Montserrat", size: 18, relativeTo: .body))
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                }
                
                Spacer()
                
                // Option Cards
                VStack(spacing: 20) {
                    // Podcast Card
                    Button(action: {}) {
                        OptionCard(
                            imageName: "Podcast-bro",
                            title: "Listen to Podcast Summary",
                            description: "Get the key points in a short audio format"
                        )
                    }
                    
                    // Audiobook Card
                    Button(action: {}) {
                        OptionCard(
                            imageName: "Audiobook-bro",
                            title: "Listen to Audiobook Summary",
                            description: "Hear the complete summary narrated"
                        )
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
        }
    }
}

// Helper view for option cards
struct OptionCard: View {
    let imageName: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            // Image
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 80)
                .padding(.leading, 8)
            
            // Text content
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(Font.custom("Montserrat", size: 16, relativeTo: .headline))
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.primary)
                
                Text(description)
                    .font(Font.custom("Montserrat", size: 12, relativeTo: .subheadline))
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            .padding(.vertical, 12)
            
            Spacer(minLength: 4)
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
                .padding(.trailing, 16)
        }
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        )
        .contentShape(Rectangle())
    }
}

#Preview {
    InsightEndPageView(
        viewModel: EndPageInsightUI.sample
    )
}
