import SwiftUI

struct InsightIdeaPageView: View {
    var body: some View {
        ZStack {
            // Background
            Color(hex: "11487A")
                .ignoresSafeArea()
            
            // Content layers
            VStack(spacing: 0) {
                // Top section with title and description
                VStack(spacing: 20) {
                    Text("Focus on Your One Thing")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.orange)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Text("Concentrate on the single most important task that will have the greatest impact on your success.")
                        .font(.title3)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                }
                .padding(.top, 60)
                
                // Center illustration image
                Spacer()
                
                // Main concept illustration without background
                AsyncImage(url: URL(string: "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 320)
                        .cornerRadius(12)
                        .padding(20)
                } placeholder: {
                    ProgressView()
                        .frame(height: 320)
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
                    AsyncImage(url: URL(string: "https://i.postimg.cc/tpgRQNV7/The-One-Thing-02-min.jpg")) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 80, height: 110)
                            .cornerRadius(8)
                            .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 2)
                    } placeholder: {
                        ProgressView()
                            .frame(width: 100, height: 130)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
            .padding()
        }
    }
}

#Preview {
    InsightIdeaPageView()
}
