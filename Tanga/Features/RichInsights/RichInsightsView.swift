import SwiftUI

struct RichInsightsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack(alignment: .top) {
            // Main content
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 0) {
                    InsightIdeaPageView()
                        .containerRelativeFrame(.vertical)
                    InsightVideoPageView()
                        .containerRelativeFrame(.vertical)
                    InsightSummaryPageView()
                        .containerRelativeFrame(.vertical)
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            .ignoresSafeArea()
            .scrollClipDisabled()
            
            // Transparent top bar with back button
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(12)
                        .background(Circle().fill(Color.black.opacity(0.3)))
                }
                .padding(.leading, 16)
                .padding(.top, 8)
                
                Spacer()
            }
            .padding(.top, 18) // Adjust for safe area
            .frame(height: 60)
        }
        .navigationBarHidden(true)
        .statusBar(hidden: true)
    }
}

#Preview {
    RichInsightsView()
        .preferredColorScheme(.dark)
}
