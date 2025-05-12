import SwiftUI

struct RichInsightsView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel: RichInsightsViewModel
    @State private var currentPage = 0
    
    init(summaryId: String, bookCoverUrl: String) {
        _viewModel = StateObject(wrappedValue: RichInsightsViewModel(summaryId: summaryId, bookCoverUrl: bookCoverUrl))
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            // Main content with dynamic pages
            if viewModel.isLoading {
                ProgressView()
                    .tint(.white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(hex: "11487A"))
                    .ignoresSafeArea()
            } else if viewModel.error != nil {
                VStack {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 50))
                        .foregroundColor(.orange)
                        .padding()
                    
                    Text("Could not load insights")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    
                    Button("Try Again") {
                        Task {
                            await viewModel.loadRichInsights()
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .foregroundColor(Color(hex: "11487A"))
                    .cornerRadius(8)
                    .padding(.top)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(hex: "11487A"))
                .ignoresSafeArea()
            } else if viewModel.hasPages {
                TabView(selection: $currentPage) {
                    ForEach(0..<viewModel.pageCount, id: \.self) { index in
                        pageView(for: index)
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .padding(.top, -10)
                .ignoresSafeArea()
            } else {
                Text("No insights available")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(hex: "11487A"))
                    .ignoresSafeArea()
            }
            
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
            //.padding(.top, 16)
            .zIndex(1) // Ensure it stays on top of other content
        }
        .navigationBarBackButtonHidden(true)
        .task {
            await viewModel.loadRichInsights()
        }
    }
    
    @ViewBuilder
    private func pageView(for index: Int) -> some View {
        if let page = viewModel.page(at: index) {
            if let ideaPage = page as? IdeaPageInsightUI {
                InsightIdeaPageView(viewModel: ideaPage)
                    .containerRelativeFrame(.vertical)
            } else if let videoPage = page as? VideoPageInsightUI {
                InsightVideoPageView(viewModel: videoPage)
                    .containerRelativeFrame(.vertical)
            } else {
                EmptyView()
            }
        } else {
            EmptyView()
        }
    }
}

#Preview {
    RichInsightsView(
        summaryId: "the-one-thing",
        bookCoverUrl: "https://i.postimg.cc/tpgRQNV7/The-One-Thing-02-min.jpg"
    )
    .preferredColorScheme(.dark)
}
