//
//  AudioPlayerViewModel.swift
//  Tanga
//
//  Created by Rygel Louv on 04/01/2025.
//

import OSLog
import SwiftUI
import AVFoundation
import FirebaseStorage
import MediaPlayer

@MainActor
class AudioPlayerViewModel: ObservableObject {
    @Published var currentTime: Double = 0.0
    @Published var duration: Double = 0.0
    @Published var isPlaying: Bool = false
    @Published var title: String = ""
    @Published var author: String = ""
    @Published var imageUrl: String = ""
    @Published var showMiniPlayer: Bool = false
    
    private var urlDownloadGenerator: DownloadUrlGenerator
    
    private var audioController: AudioController
    
    var playingSummary: Summary? {
        audioController.currentSummary
    }
    
    init(urlDownloadGenerator: DownloadUrlGenerator, audioController: AudioController) {
        self.urlDownloadGenerator = urlDownloadGenerator
        self.audioController = audioController
        setupAudioManagerCallbacks()
    }
    
    private func setupAudioManagerCallbacks() {
        audioController.onPlaybackUpdate = { [weak self] currentTime, duration, isPlaying in
            DispatchQueue.main.async {
                self?.currentTime = currentTime
                self?.duration = duration
                self?.isPlaying = isPlaying
            }
        }
    }
    
    func loadAudio(summary: Summary) {
        guard let summaryId = summary.id else { return }
        
        DispatchQueue.main.async {
            self.title = summary.title ?? "Unknown Title"
            self.author = summary.author ?? "Unknown Author"
            self.imageUrl = summary.coverImageUrl ?? ""
        }
        
        // Check if the requested summary is already playing
        if let currentSummaryId = playingSummary?.id, currentSummaryId == summaryId {
            // Already playing the same summary
            return
        }
        
        // Stop the current playback and prepare for the new summary
        audioController.stopPlayback()
        
        // Generate URL and configure the player
        Task {
            let url = try await urlDownloadGenerator.generate(summaryId: summaryId)
            if let url = url {
                do {
                    try await audioController.loadAudio(summary: summary, url: url)
                } catch {
                    Logger.audioPlayer.error("Error loading audio: \(error)")
                }
            }
        }
    }
    
    func togglePlayPause() {
        if (!isReadyToPlay()) { return }
        audioController.togglePlayPause()
    }
    
    func seek(to time: Double) {
        audioController.seek(to: time)
    }
    
    func stopPlayback() {
        audioController.stopPlayback()
        showMiniPlayer = false
    }
    
    /// Shows the mini player
    func showMiniPlayerView() {
        showMiniPlayer = true
    }

    /// Hides the mini player
    func hideMiniPlayerView() {
        showMiniPlayer = false
    }
    
    /// Skips forward by 10 seconds
    func skipForward() {
        audioController.skipForward()
    }

    /// Skips backward by 10 seconds
    func skipBackward() {
        audioController.skipBackward()
    }
    
    /// Formats a time value in seconds as MM:SS
    func formattedTime(_ time: Double) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func isReadyToPlay() -> Bool {
        return duration > 0
    }
    
    deinit {
        audioController.releasePlayer()
    }
}
