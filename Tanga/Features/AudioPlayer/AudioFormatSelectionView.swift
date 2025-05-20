//
//  AudioFormatSelectionView.swift
//  Tanga
//
//  Created by Rygel Louv on 13/05/2025.
//

import SwiftUI
import OSLog

struct AudioFormatSelectionView: View {
    let summary: Summary
    @Binding var isPresented: Bool
    var onFormatSelected: (AudioFormat) -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            // Header
            VStack(spacing: 16) {
                Text("Choose Audio Format")
                    .font(Font.custom("Montserrat", size: 22, relativeTo: .title2))
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                
                Text("Select how you'd like to listen to this summary")
                    .font(Font.custom("Montserrat", size: 16, relativeTo: .body))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .padding(.top)
            
            // Option Cards
            VStack(spacing: 20) {
                // Podcast Card
                Button {
                    Logger.audioPlayer.info("[AudioFormatSelectionView] User selected PODCAST format")
                    onFormatSelected(.podcast)
                    isPresented = false
                } label: {
                    AudioFormatOptionCard(format: .podcast)
                }
                
                // Audiobook Card
                Button {
                    Logger.audioPlayer.info("[AudioFormatSelectionView] User selected AUDIOBOOK format")
                    onFormatSelected(.audiobook)
                    isPresented = false
                } label: {
                    AudioFormatOptionCard(format: .audiobook)
                }
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding()
        .background(Color(UIColor.systemGray6))
    }
}

struct AudioFormatOptionCard: View {
    let format: AudioFormat
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            // Image
            Image(format.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 80)
                .padding(.leading, 8)
            
            // Text content
            VStack(alignment: .leading, spacing: 4) {
                Text("Listen to \(format.title)")
                    .font(Font.custom("Montserrat", size: 16, relativeTo: .headline))
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.primary)
                
                Text(format.description)
                    .font(Font.custom("Montserrat", size: 12, relativeTo: .subheadline))
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            .padding(.vertical, 12)
            
            Spacer(minLength: 4)
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
                .padding(.trailing, 16)
        }
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        )
        .contentShape(Rectangle())
    }
}

#Preview {
    AudioFormatSelectionView(
        summary: dummySummaries[0],
        isPresented: .constant(true),
        onFormatSelected: { _ in }
    )
    .previewLayout(.sizeThatFits)
}
