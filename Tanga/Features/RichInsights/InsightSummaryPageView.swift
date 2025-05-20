import SwiftUI

struct InsightSummaryPageView: View {
    let summaries: [String] = [
        "Key Idea 1: Focus on one thing",
        "Key Idea 2: Prioritize impact",
        "Key Idea 3: Success through clarity"
    ]
    let colors: [Color] = [.green, .orange, .purple]
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 24) {
                ForEach(0..<summaries.count, id: \.self) { idx in
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(colors[idx % colors.count])
                            .frame(height: geometry.size.height / 5)
                        Text(summaries[idx])
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                            .padding()
                    }
                    .padding(.horizontal, 24)
                }
                Spacer()
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(Color(.systemBackground))
        }
        .ignoresSafeArea()
    }
}

#Preview {
    InsightSummaryPageView()
}
