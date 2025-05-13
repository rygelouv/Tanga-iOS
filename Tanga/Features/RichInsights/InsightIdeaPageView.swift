import SwiftUI

struct InsightIdeaPageView: View {
    let viewModel: IdeaPageInsightUI
    
    var body: some View {
        ZStack {
            // Background
            Color(hex: "11487A")
                .ignoresSafeArea()
            
            // Content layers
            VStack(spacing: 0) {
                Spacer(minLength: 40)
                // Top section with title and description
                /*VStack(spacing: 20) {
                    Text(viewModel.title)
                        .font(Font.custom("Montserrat", size: 22, relativeTo: .title))
                        .fontWeight(.semibold)
                        .foregroundColor(.orange)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Text(viewModel.description)
                        .font(Font.custom("Montserrat", size: 18, relativeTo: .body))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                }
                .padding(.top, 60)
                
                // Center illustration image
                Spacer()*/
                
                // Main concept illustration without background
                AsyncImage(url: URL(string: viewModel.illustrationUrl)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(12)
                        .padding(20)
                } placeholder: {
                    ProgressView()
                        .frame(height: 360)
                }
                
                Spacer()
                
                // Bottom section with logos
                HStack {
                    // Tanga logo with text underneath
                    VStack(spacing: 5) {
                        Image("tanga-logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 60, height: 60)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .padding(.top, 8)
                        
                        Text("Tanga")
                            .font(.caption)
                            .foregroundColor(.yaleBlue)
                            .fontWeight(.medium)
                            .padding(.bottom, 8)
                    }
                    .padding(.horizontal, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white)
                            .shadow(radius: 2)
                    )
                    
                    Spacer()
                    
                    // Book cover
                    SummaryImageView(url: viewModel.bookCoverUrl)
                        .frame(width: 80, height: 110)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
            .padding()
        }
    }
}

#Preview {
    InsightIdeaPageView(viewModel: RichInsight(
        id: "book_summary_id",
        number: 1,
        title: "Focus on Your One Thing",
        description: "Concentrate on the single most important task that will have the greatest impact on your success.",
        illustrationUrl: "https://ik.imagekit.io/tangaimages/onething_img2_tiny.png",
        videoUrl: "https://ik.imagekit.io/tangaimages/onething_img2_tiny.png"
    ).toIdeaPageUI(bookCoverUrl: "https://i.postimg.cc/tpgRQNV7/The-One-Thing-02-min.jpg"))
}
