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
    @Published var currentAudioFormat: AudioFormat? = nil
    
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
    

    
    func loadAudio(summary: Summary, audioFormat: AudioFormat) {
        Logger.audioPlayer.info("[AudioPlayerViewModel] loadAudio - Received format parameter: \(String(describing: audioFormat))")
        
        Logger.audioPlayer.info("[AudioPlayerViewModel] loadAudio - Updated currentAudioFormat to: \(String(describing: self.currentAudioFormat))")
        
        guard let summaryId = summary.id else { return }
        
        DispatchQueue.main.async {
            self.title = summary.title ?? "Unknown Title"
            self.author = summary.author ?? "Unknown Author"
            self.imageUrl = summary.coverImageUrl ?? ""
        }
        
        // Check if the requested summary is already playing and with the same format
        if let currentSummaryId = playingSummary?.id, currentSummaryId == summaryId,
           currentAudioFormat == audioFormat {
            print("same audio file laoded with same format")
            // Already playing the same summary with the same format
            return
        }
        
        // Set the current format
        self.currentAudioFormat = audioFormat
        
        // Stop the current playback and prepare for the new summary
        audioController.stopPlayback()
        
        // Generate URL and configure the player
        Task {
            do {
                if let url = try await urlDownloadGenerator.generate(summaryId: summaryId, audioFormat: audioFormat) {
                    try await audioController.loadAudio(summary: summary, url: url)
                } else {
                    Logger.audioPlayer.error("[AudioPlayerViewModel] Task - Failed to generate URL")
                }
            } catch {
                Logger.audioPlayer.error("[AudioPlayerViewModel] Task - Error loading audio: \(error)")
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
