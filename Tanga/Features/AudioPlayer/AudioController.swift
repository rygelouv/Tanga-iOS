//
//  AudioController.swift
//  Tanga
//
//  Created by Rygel Louv on 06/01/2025.
//

import Foundation
import AVFoundation
import MediaPlayer

class AudioController {
    private var player: AVPlayer?
    private var timeObserver: Any?
    private var currentTime: Double = 0.0
    
    private(set) var currentSummary: Summary?
    
    // Callbacks for UI updates
    var onPlaybackUpdate: ((Double, Double, Bool) -> Void)? // currentTime, duration, isPlaying
    var onNowPlayingInfoUpdate: (() -> Void)?
    
    init() {
        configureAudioSession()
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
    
    // REMOVE this function
    func loadAudio(summary: Summary, url: URL) async throws {
        currentSummary = summary
        
        setupPlayer(with: url)
    }
    
    private func setupPlayer(with url: URL) {
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        
        Task {
            do {
                let duration = try await playerItem.asset.load(.duration)
                DispatchQueue.main.async { [weak self] in
                    self?.onPlaybackUpdate?(0.0, duration.seconds, false)
                }
            } catch {
                print("Error loading audio duration: \(error)")
            }
        }
        
        // Add time observer
        timeObserver = player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: .main) { [weak self] time in
            guard let self = self else { return }
            currentTime = time.seconds
            self.onPlaybackUpdate?(currentTime, self.player?.currentItem?.duration.seconds ?? 0.0, self.player?.timeControlStatus == .playing)
        }
        
        configureNowPlayingInfo(for: url)
        setupRemoteCommands()
    }
    
    private func configureNowPlayingInfo(for url: URL) {
        guard let currentSummary = currentSummary else { return }
        
        let nowPlayingInfoCenter = MPNowPlayingInfoCenter.default()
        var nowPlayingInfo: [String: Any] = [
            MPMediaItemPropertyTitle: currentSummary.title ?? "Unknown Title",
            MPMediaItemPropertyArtist: currentSummary.author ?? "Unknown Author",
            MPNowPlayingInfoPropertyElapsedPlaybackTime: player?.currentTime().seconds ?? 0.0,
            MPMediaItemPropertyPlaybackDuration: player?.currentItem?.duration.seconds ?? 0.0,
            MPNowPlayingInfoPropertyPlaybackRate: player?.timeControlStatus == .playing ? 1.0 : 0.0
        ]
        
        // Load artwork asynchronously
        if let imageUrl = currentSummary.coverImageUrl {
            loadArtworkImage(from: imageUrl) { image in
                if let image = image {
                    nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: image.size) { _ in
                        return image
                    }
                }
                nowPlayingInfoCenter.nowPlayingInfo = nowPlayingInfo
            }
        } else {
            nowPlayingInfoCenter.nowPlayingInfo = nowPlayingInfo
        }
    }
    
    private func loadArtworkImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
        }.resume()
    }
    
    private func setupRemoteCommands() {
        let commandCenter = MPRemoteCommandCenter.shared()

        commandCenter.playCommand.addTarget { [weak self] _ in
            self?.togglePlayPause()
            return .success
        }

        commandCenter.pauseCommand.addTarget { [weak self] _ in
            self?.togglePlayPause()
            return .success
        }

        commandCenter.skipForwardCommand.addTarget { [weak self] _ in
            self?.skipForward()
            return .success
        }
        commandCenter.skipForwardCommand.isEnabled = true
        commandCenter.skipForwardCommand.preferredIntervals = [10] // Skip by 10 seconds

        commandCenter.skipBackwardCommand.addTarget { [weak self] _ in
            self?.skipBackward()
            return .success
        }
        commandCenter.skipBackwardCommand.isEnabled = true
            commandCenter.skipBackwardCommand.preferredIntervals = [10] // Skip by 10 seconds

        // Change Playback Position Command (Slider)
        commandCenter.changePlaybackPositionCommand.addTarget { [weak self] event in
            guard let self = self, let positionEvent = event as? MPChangePlaybackPositionCommandEvent else {
                return .commandFailed
            }

            self.seek(to: positionEvent.positionTime)
            return .success
        }
        commandCenter.changePlaybackPositionCommand.isEnabled = true
    }
    
    func togglePlayPause() {
        guard let player = player else { return }
        if player.timeControlStatus == .playing {
            player.pause()
        } else {
            player.play()
        }
        currentTime = player.currentTime().seconds
        onPlaybackUpdate?(currentTime, player.currentItem?.duration.seconds ?? 0.0, player.timeControlStatus == .playing)
    }
    
    func seek(to time: Double) {
        player?.seek(to: CMTime(seconds: time, preferredTimescale: 1))
        currentTime = time
        onPlaybackUpdate?(time, player?.currentItem?.duration.seconds ?? 0.0, player?.timeControlStatus == .playing)
    }
    
    func stopPlayback() {
        player?.pause()
        player = nil
        currentSummary = nil
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
        currentTime = 0.0
        onPlaybackUpdate?(0.0, 0.0, false)
    }
    
    /// Skips forward by 10 seconds
    func skipForward() {
        seek(to: currentTime + 10)
    }

    /// Skips backward by 10 seconds
    func skipBackward() {
        seek(to: currentTime - 10)
    }
    
    func releasePlayer() {
        if let observer = timeObserver {
            player?.removeTimeObserver(observer)
        }
    }
}
