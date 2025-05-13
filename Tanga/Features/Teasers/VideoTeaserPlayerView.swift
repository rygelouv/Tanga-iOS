//
//  VideoTeaserPlayerView.swift
//  Tanga
//
//  Created by Rygel Louv on 13/05/2025.
//

import SwiftUI
import AVFoundation
import AVKit
import Combine

struct VideoTeaserPlayerView: View {
    let videoUrl: String
    @Environment(\.presentationMode) var presentationMode
    @State private var player: AVPlayer?
    @State private var isLoading = true
    @State private var isBuffering = false
    @State private var playerItemObserver: AnyCancellable?
    @State private var timeObserver: Any?
    
    var body: some View {
        ZStack {
            // Video player
            if let player = player {
                VideoPlayer(player: player)
                    .scaledToFill()
                    //.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .ignoresSafeArea()
            } else {
                Color.black
                    .ignoresSafeArea()
            }
            
            // Loading overlay
            if isLoading || isBuffering {
                Color.black.opacity(0.7)
                    .ignoresSafeArea()
                
                VStack(spacing: 16) {
                    ProgressView()
                        .tint(.white)
                        .scaleEffect(1.5)
                    
                    Text(isLoading ? "Loading video..." : "Buffering...")
                        .font(Font.custom("Montserrat", size: 16, relativeTo: .body))
                        .foregroundColor(.white)
                }
            }
            
            // Close button
            // TODO for some reason this button is not showing up for now. Looks like the video player is covering it
            // we must fix this.
            VStack {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(12)
                            .background(Circle().fill(Color.black.opacity(0.3)))
                    }
                    .padding(.leading, 16)
                    .padding(.top, 16)
                    
                    Spacer()
                }
                
                Spacer()
            }.zIndex(2) // Ensure it's above everything else
        }
        .onAppear {
            setupPlayer()
        }
        .onDisappear {
            cleanupPlayer()
        }
        .navigationBarBackButtonHidden(true)
        //.edgesIgnoringSafeArea(.all)
    }

    private func setupPlayer() {
        guard let url = URL(string: videoUrl) else { return }
        
        let playerItem = AVPlayerItem(url: url)
        let player = AVPlayer(playerItem: playerItem)
        self.player = player
        
        // Observe player item status
        playerItemObserver = playerItem.publisher(for: \.status)
            .receive(on: RunLoop.main)
            .sink { status in
                switch status {
                case .readyToPlay:
                    self.isLoading = false
                    player.play()
                    // Video is ready to play
                case .failed:
                    self.isLoading = false
                    // Handle error
                default:
                    break
                }
            }
        
        // Observe buffering
        timeObserver = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.5, preferredTimescale: 600), queue: .main) { _ in
            if player.currentItem?.isPlaybackLikelyToKeepUp == false {
                self.isBuffering = true
            } else {
                self.isBuffering = false
            }
        }
        
        // Loop video when it ends
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem,
            queue: .main) { _ in
                player.seek(to: .zero)
                player.play()
            }
    }
    
    private func cleanupPlayer() {
        player?.pause()
        
        if let timeObserver = timeObserver {
            player?.removeTimeObserver(timeObserver)
            self.timeObserver = nil
        }
        
        playerItemObserver?.cancel()
        NotificationCenter.default.removeObserver(self)
    }
}

#Preview {
    VideoTeaserPlayerView(videoUrl: "https://ik.imagekit.io/tangaimages/4506871-hd_720_1366_50fps.mp4")
}
