//
//  AudioPlayerView.swift
//  Tanga
//
//  Created by Rygel Louv on 04/01/2025.
//

import SwiftUI
import AVFoundation
import FirebaseStorage


struct AudioPlayerView: View {
    let  summary: Summary
    
    @EnvironmentObject var audioPlayerViewModel: AudioPlayerViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        
        VStack {
            // Header Section
            AudioPlayerHeader(imageUrl: audioPlayerViewModel.imageUrl, title: audioPlayerViewModel.title)
            
            Spacer()
            
            // Slider and Time Labels Section
            AudioPlayerSliderAndTimeLabels(
                currentTime: $audioPlayerViewModel.currentTime,
                duration: audioPlayerViewModel.duration,
                formattedTime: audioPlayerViewModel.formattedTime
            ) {
                audioPlayerViewModel.seek(to: $0)
            }
            
            // Play/Pause and Controls Section
            AudioPlayerControls(
                isPlaying: audioPlayerViewModel.isPlaying,
                onPlayPauseToggle: audioPlayerViewModel.togglePlayPause,
                onSkipBackward: audioPlayerViewModel.skipBackward,
                onSkipForward: audioPlayerViewModel.skipForward
            )
            
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    audioPlayerViewModel.showMiniPlayerView()
                    dismiss()
                }) {
                    Image("left-arrow")
                        .resizable()
                        .renderingMode(.template)
                        .font(.system(size: 24))
                        .frame(width: 26, height: 26)
                        .foregroundColor(.black)
                }
            }
        }
        .padding()
        .onAppear {
            audioPlayerViewModel.hideMiniPlayerView()
            audioPlayerViewModel.loadAudio(summary: summary)
        }
        .onDisappear {
            audioPlayerViewModel.showMiniPlayerView()
        }
    }
    
    // MARK: Summary information
    struct AudioPlayerHeader: View {
        let imageUrl: String
        let title: String
        
        var body: some View {
            VStack {
                // Image at the top
                AsyncImage(url: URL(string: imageUrl)) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 200)
                
                // Title
                Text(title)
                    .font(.title)
                    .padding()
            }
        }
    }

    // MARK: Slider and Time Labels
    struct AudioPlayerSliderAndTimeLabels: View {
        @Binding var currentTime: Double
        let duration: Double
        let formattedTime: (Double) -> String
        let onSeek: (Double) -> Void
        
        var body: some View {
            VStack {
                // Slider
                Slider(value: $currentTime, in: 0...duration, onEditingChanged: { editing in
                    if !editing {
                        onSeek(currentTime)
                    }
                })
                .padding()
                
                // Time Labels
                HStack {
                    Text(formattedTime(currentTime))
                    Spacer()
                    Text(formattedTime(duration))
                }
                .padding(.horizontal)
            }
        }
    }

    // MARK: Audio Playback controls
    struct AudioPlayerControls: View {
        let isPlaying: Bool
        let onPlayPauseToggle: () -> Void
        let onSkipBackward: () -> Void
        let onSkipForward: () -> Void
        
        var body: some View {
            HStack {
                // Skip Backward
                Button(action: onSkipBackward) {
                    Image(systemName: "gobackward.10")
                        .font(.largeTitle)
                        .padding()
                }
                
                // Play/Pause
                Button(action: onPlayPauseToggle) {
                    Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .font(.largeTitle)
                        .padding()
                }
                
                // Skip Forward
                Button(action: onSkipForward) {
                    Image(systemName: "goforward.10")
                        .font(.largeTitle)
                        .padding()
                }
            }
        }
    }
}

#Preview {
    AudioPlayerView(summary: dummySummaries[0])
}
