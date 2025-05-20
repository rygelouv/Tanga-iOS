import SwiftUI
import AVFoundation
import AVKit

struct InsightVideoPageView: View {
    let viewModel: VideoPageInsightUI
    @State private var player: AVPlayer?
    
    var body: some View {
        ZStack {
            if let player = player {
                VideoPlayer(player: player)
                    .scaledToFill()
                    .ignoresSafeArea()
            } else {
                Color.black
                    .ignoresSafeArea()
                ProgressView()
                    .tint(.white)
            }
        }
        .onAppear {
            setupPlayer()
        }
        .onDisappear {
            player?.pause()
            NotificationCenter.default.removeObserver(self)
        }
    }
    
    private func setupPlayer() {
        guard let url = URL(string: viewModel.videoUrl) else { return }
        
        let player = AVPlayer(url: url)
        self.player = player
        player.play()
        
        // Loop video when it ends
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem,
            queue: .main) { _ in
                player.seek(to: .zero)
                player.play()
            }
    }
}

#Preview {
    InsightVideoPageView(viewModel: RichInsight(
        id: "book_summary_id",
        number: 1,
        title: "Focus on Your One Thing",
        description: "Concentrate on the single most important task that will have the greatest impact on your success.",
        illustrationUrl: "https://ik.imagekit.io/tangaimages/onething_img2_tiny.png",
        videoUrl: "https://ik.imagekit.io/tangaimages/onething_img2_tiny.png"
    ).toVideoPageUI())
}
