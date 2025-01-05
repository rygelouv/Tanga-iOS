//
//  AudioPlayerViewModel.swift
//  Tanga
//
//  Created by Rygel Louv on 04/01/2025.
//

import SwiftUI
import AVFoundation
import FirebaseStorage
import MediaPlayer

@MainActor
class AudioPlayerViewModel: ObservableObject {
    @Published var currentTime: Double = 0.0
    @Published var duration: Double = 0.0
    @Published var isPlaying = false
    @Published var imageUrl: String = ""
    @Published var title: String = ""
    @Published var author: String = ""
    @Published var showMiniPlayer = false // To control the mini player's visibility
    
    private var player: AVPlayer?
    private var timeObserver: Any?
    
    private var urlDownloadGenerator: DownloadUrlGenerator
    var playingSummary: Summary? // Tracks the currently playing summary
    
    init(urlDownloadGenerator: DownloadUrlGenerator) {
        self.urlDownloadGenerator = urlDownloadGenerator
    }
    
    private func configureAudioSession() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .spokenAudio)
            try session.setActive(true)
        } catch {
            print("Failed to configure audio session: \(error)")
        }
    }
    
    /// Handles loading audio based on the summary and current playback state
    func loadAudio(summary: Summary) {
        guard let summaryId = summary.id else { return }
        
        // Check if the requested summary is already playing
        if let playingSummaryId = playingSummary?.id, playingSummaryId == summaryId {
            //Already playing the same summary
            return // No changes needed; keep the current playback state
        }
        
        // If a different summary is requested or nothing is playing
        stopPlayback() // Stop any existing playback
        
        // Update UI-related properties
        DispatchQueue.main.async {
            self.title = summary.title ?? "Unknown Title"
            self.author = summary.author ?? "Unknown Author"
            self.imageUrl = summary.coverImageUrl ?? ""
            self.currentTime = 0.0
            self.duration = 0.0
        }
        
        // Generate the audio URL and set up the player
        Task {
            do {
                let url = try await urlDownloadGenerator.generate(summaryId: summaryId)
                if let url = url {
                    self.setupPlayer(with: url)
                    self.playingSummary = summary // Update to the new playing summary
                }
            } catch {
                print("Error downloading audio: \(error)")
            }
        }
    }
    
    /// Configures the AVPlayer with the new audio URL
    private func setupPlayer(with url: URL) {
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        
        Task {
            do {
                let duration = try await playerItem.asset.load(.duration)
                DispatchQueue.main.async {
                    self.duration = duration.seconds
                    self.configureAudioSession()
                }
            } catch {
                print("Error loading audio duration")
            }
        }
        
        // Add a periodic time observer for playback progress
        timeObserver = player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: .main) { [weak self] time in
            DispatchQueue.main.async {
                self?.currentTime = time.seconds
                self?.updateNowPlayingInfo()
            }
        }
        
        configureNowPlayingInfo(for: url)
    }
    
    private func configureNowPlayingInfo(for url: URL) {
        let nowPlayingInfoCenter = MPNowPlayingInfoCenter.default()
        var nowPlayingInfo: [String: Any] = [
            MPMediaItemPropertyTitle: title,
            MPMediaItemPropertyArtist: author,
            MPNowPlayingInfoPropertyElapsedPlaybackTime: currentTime,
            MPMediaItemPropertyPlaybackDuration: duration,
            MPNowPlayingInfoPropertyPlaybackRate: isPlaying ? 1.0 : 0.0
        ]
        
        // Load artwork asynchronously from the provided URL
        loadArtworkImage(from: imageUrl) { image in
            if let image = image {
                nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: image.size) { _ in
                    return image
                }
                nowPlayingInfoCenter.nowPlayingInfo = nowPlayingInfo
            } else {
                nowPlayingInfoCenter.nowPlayingInfo = nowPlayingInfo
            }
        }
    }
    
    private func updateNowPlayingInfo() {
        guard var nowPlayingInfo = MPNowPlayingInfoCenter.default().nowPlayingInfo else { return }
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = currentTime
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = isPlaying ? 1.0 : 0.0
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    private func loadArtworkImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        // Fetch image data asynchronously
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, error == nil {
                let image = UIImage(data: data)
                completion(image)
            } else {
                completion(nil)
            }
        }.resume()
    }
    
    /// Shows the mini player
    func showMiniPlayerView() {
        showMiniPlayer = true
    }
    
    /// Hides the mini player
    func hideMiniPlayerView() {
        showMiniPlayer = false
    }
    
    /// Stops playback and resets the state
    func stopPlayback() {
        currentTime = 0.0
        duration = 0.0
        playingSummary = nil
        isPlaying = false
        player?.pause()
        player = nil
        hideMiniPlayerView()
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
    }
    
    /// Toggles playback between play and pause
    func togglePlayPause() {
        guard let player = player else { return }
        if player.timeControlStatus == .playing {
            player.pause()
            isPlaying = false
        } else {
            player.play()
            isPlaying = true
            updateNowPlayingInfo()
        }
    }
    
    /// Seeks to a specific time
    func seek(to time: Double) {
        player?.seek(to: CMTime(seconds: time, preferredTimescale: 1))
    }
    
    /// Skips forward by 10 seconds
    func skipForward() {
        seek(to: currentTime + 10)
    }
    
    /// Skips backward by 10 seconds
    func skipBackward() {
        seek(to: currentTime - 10)
    }
    
    /// Formats a time value in seconds as MM:SS
    func formattedTime(_ time: Double) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    deinit {
        if let observer = timeObserver {
            player?.removeTimeObserver(observer)
        }
    }
}
