//
//  MiniPlayerView.swift
//  Tanga
//
//  Created by Rygel Louv on 05/01/2025.
//

import SwiftUI
import FirebaseStorage

struct MiniPlayerView: View {
    @EnvironmentObject var audioPlayerViewModel: AudioPlayerViewModel
    
    var body: some View {
        HStack {
            // Image
            AsyncImage(url: URL(string: audioPlayerViewModel.imageUrl)) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                Color.gray
            }
            .frame(width: 50, height: 50)
            .cornerRadius(8)
            
            // Title
            Text(audioPlayerViewModel.title)
                .font(.headline)
                .lineLimit(1)
                .padding(.horizontal, 8)
            
            Spacer()
            
            // Play/Pause Button
            Button(action: {
                audioPlayerViewModel.togglePlayPause()
            }) {
                Image(systemName: audioPlayerViewModel.isPlaying ? "pause.fill" : "play.fill")
                    .font(.title2)
            }
            .padding(.horizontal, 8)
            
            // Close Button
            Button(action: {
                audioPlayerViewModel.stopPlayback()
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.title2)
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
        .shadow(radius: 4)
        .padding(.horizontal)
    }
}
