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
                    .aspectRatio(contentMode: .fill)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
            } placeholder: {
                Color.gray
            }
            .frame(width: 40, height: 40 )
            .cornerRadius(8)
            
            //SummaryImageView(url: audioPlayerViewModel.imageUrl).frame(width: 50, height: 50)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(audioPlayerViewModel.title)
                    .font(Font.custom("Montserrat", size: 14, relativeTo: .body))
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .foregroundColor(Color.white)
                    .padding(.horizontal, 8)
                
                Text(audioPlayerViewModel.author)
                    .font(Font.custom("Montserrat", size: 12, relativeTo: .body))
                    .fontWeight(.regular)
                    .lineLimit(1)
                    .foregroundColor(Color.white)
                    .padding(.horizontal, 8)
            }
            
            Spacer()
            
            // Play/Pause Button
            Button(action: {
                audioPlayerViewModel.togglePlayPause()
            }) {
                Image(systemName: audioPlayerViewModel.isPlaying ? "pause.fill" : "play.fill")
                    .font(.title2)
                    .foregroundColor(Color.white)
            }
            .padding(.horizontal, 8)
            
            // Close Button
            Button(action: {
                audioPlayerViewModel.stopPlayback()
            }) {
                Image(systemName: "xmark")
                    .font(.title2)
                    .foregroundColor(Color.white)
                    .padding(.leading, 8)
            }
        }
        .padding()
        .background(Color.navy)
        .cornerRadius(12)
        .shadow(radius: 4)
        .padding(.horizontal)
    }
}
