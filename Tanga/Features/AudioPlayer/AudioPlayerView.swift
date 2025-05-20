//
//  AudioPlayerView.swift
//  Tanga
//
//  Created by Rygel Louv on 04/01/2025.
//

import SwiftUI
import AVFoundation
import FirebaseStorage
import OSLog


struct AudioPlayerView: View {
    let summary: Summary
    let audioFormat: AudioFormat
    
    init(summary: Summary, audioFormat: AudioFormat) {
        self.summary = summary
        self.audioFormat = audioFormat
        print("🔍 AudioPlayerView initialized with format: \(audioFormat) for summary: \(summary.title ?? "Untitled")")
    }
    
    @EnvironmentObject var audioPlayerViewModel: AudioPlayerViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        
        ZStack {
            ScrollView {
                ZStack {
                    VStack {
                        Spacer(minLength: 100)
                        
                        Divider().frame( width: 30, height: 4).overlay(.gray.opacity(0.1)).padding(.vertical, 30)
                        
                        Spacer()
                        
                        // Format Badge
                        VStack {
                            HStack(spacing: 6) {
                                Image(systemName: audioFormat == .podcast ? "mic.fill" : "headphones")
                                    .foregroundColor(.yaleBlue)
                                    .font(.system(size: 14, weight: .semibold))
                                Text(audioFormat == .podcast ? "Podcast" : "Audiobook")
                                    .font(Font.custom("Montserrat", size: 12, relativeTo: .caption))
                                    .foregroundColor(.yaleBlue)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.yaleBlue.opacity(0.1))
                            .cornerRadius(16)
                            .padding(.trailing, 16)

                            Spacer(minLength: 20)
                        }
                        
                        // Header Section
                        AudioPlayerHeader(title: summary.title ?? "", author: summary.author ?? "")
                        
                        Spacer(minLength: 50)
                        
                        // Slider and Time Labels Section
                        AudioPlayerSliderAndTimeLabels(
                            currentTime: $audioPlayerViewModel.currentTime,
                            duration: audioPlayerViewModel.duration,
                            formattedTime: audioPlayerViewModel.formattedTime
                        ) {
                            audioPlayerViewModel.seek(to: $0)
                        }
                        
                        Spacer(minLength: 20)
                        
                        // Play/Pause and Controls Section
                        AudioPlayerControls(
                            isPlaying: audioPlayerViewModel.isPlaying,
                            onPlayPauseToggle: audioPlayerViewModel.togglePlayPause,
                            onSkipBackward: audioPlayerViewModel.skipBackward,
                            onSkipForward: audioPlayerViewModel.skipForward
                        )
                        
                        Spacer(minLength: 200)
                    }.background(Color.white)
                        .clipShape(
                            RoundedCornerShape(corners: [.topLeft, .topRight], radius: 40)
                        )
                        .padding(.top, 140)
                        .frame(maxHeight: .infinity)
                    
                    // Image at the top
                    VStack {
                        SummaryImageView(url: summary.coverImageUrl ?? "").frame(width: 160).padding(.top, 20)
                        Spacer()
                    }.frame(maxHeight: .infinity)
                }
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
                            .foregroundColor(.gray)
                    }
                }
            }
            .toolbarBackground(Color.cultured, for: .navigationBar)
            .background(Color.cultured)
            .task {
                print("💻 AudioPlayerView task - Using format: \(audioFormat)")
                // Load audio with the directly passed format parameter
                audioPlayerViewModel.loadAudio(summary: summary, audioFormat: audioFormat)
                audioPlayerViewModel.hideMiniPlayerView()
            }
            .onDisappear {
                audioPlayerViewModel.showMiniPlayerView()
            }
            
            if audioPlayerViewModel.duration <= 0 {
                LoadingView()
            }
        }
    }
    
    // MARK: Summary information
    struct AudioPlayerHeader: View {
        let title: String
        let author: String
        
        var body: some View {
            VStack {
                
                // Title
                Text(title)
                    .fontWeight(.bold)
                    .font(Font.custom("Montserrat", size: 22, relativeTo: .title))
                    .foregroundColor(.navy)
                    .padding(.bottom, 8)
                
                Text(author)
                    .fontWeight(.bold)
                    .font(Font.custom("Montserrat", size: 16, relativeTo: .title2))
                    .foregroundStyle(Color.auroMetalSaurus)
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
                Slider(value: $currentTime, in: 0...max(0, duration), onEditingChanged: { editing in
                    if !editing {
                        onSeek(currentTime)
                    }
                })
                .padding(.bottom, 4)
                
                // Time Labels
                HStack {
                    Text(formattedTime(currentTime))
                        .font(Font.custom("Montserrat", size: 12, relativeTo: .body))
                        .fontWeight(.regular)
                        .foregroundStyle(Color.auroMetalSaurus)
                    Spacer()
                    Text(formattedTime(duration))
                        .font(Font.custom("Montserrat", size: 12, relativeTo: .body))
                        .fontWeight(.regular)
                        .foregroundStyle(Color.auroMetalSaurus)
                }
                .padding(.horizontal, 8)
            }.padding()
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
                        .font(.title)
                        .foregroundColor(.yaleBlue)
                        .padding()
                }
                
                // Play/Pause
                Button(action: onPlayPauseToggle) {
                    Image(isPlaying ? "pause" : "play")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                        .frame(width: 18, height: 18)
                        .padding()
                }
                .padding(.leading, 38)
                .padding(.trailing, 38)
                .frame(minHeight: 76)
                .background(Color.yaleBlue)
                .clipShape(Circle())
                
                // Skip Forward
                Button(action: onSkipForward) {
                    Image(systemName: "goforward.10")
                        .font(.title)
                        .foregroundColor(.yaleBlue)
                        .padding()
                }
            }
        }
    }
}

#if DEBUG
#Preview {
    AudioPlayerView(summary: dummySummaries[0], audioFormat: .podcast)
        .environmentObject(AudioPlayerViewModel(
            urlDownloadGenerator: DownloadUrlGenerator(storage: Storage.storage()),
            audioController: AudioController()
        ))
}
#endif
