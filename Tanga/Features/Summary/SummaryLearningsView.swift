//
//  SummaryLearningsView.swift
//  Tanga
//
//  Created by Rygel Louv on 06/01/2025.
//

import SwiftUI

struct SummaryLearningsView: View {
    let keyLearnings: [String]
    let videoUrl: String
    
    
    var body : some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6).stroke(Color.auroMetalSaurus.opacity(0.3), lineWidth: 1)
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Key Ideas")
                        .fontWeight(.bold)
                        .font(Font.custom("Montserrat", size: 16, relativeTo: .title))
                        .foregroundColor(Color.navy)
                    
                    Spacer()
                    
                    VideoTeaserButtonView(videoUrl: videoUrl)
                }
                
                ForEach (keyLearnings, id: \.self) { keyLearning in
                    KeyLearningsItemView(text: keyLearning)
                }.padding(.vertical, 2)
            }.padding(14)
        }
    }
    
    struct VideoTeaserButtonView: View {
        let videoUrl: String
        @State private var showVideoTeaser = false
        
        var body: some View {
            Button(action: {
                showVideoTeaser = true
            }) {
                // Keep the same HStack content with the play icon and text
                HStack(spacing: 8) {
                    Image(systemName: "play.circle.fill")
                        .foregroundColor(Color.orange)
                    
                    Text("Video Teaser")
                        .font(Font.custom("Montserrat", size: 14, relativeTo: .body))
                        .fontWeight(.medium)
                        .foregroundColor(Color.orange)
                }
                .padding(.vertical, 6)
                .padding(.horizontal, 12)
                .background(
                    RoundedRectangle(cornerRadius: 20).fill(.white)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                )
            }
            .sheet(isPresented: $showVideoTeaser) {
                VideoTeaserPlayerView(videoUrl: videoUrl)
            }
        }
    }

    struct KeyLearningsItemView: View {
        let text: String
        
        var body: some View {
            HStack {
                HStack(spacing: 10) {
                    Image("check")
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 18, height: 18)
                        .foregroundColor(.yaleBlue)
                    
                    Text(text)
                        .font(Font.custom("Montserrat", size: 13, relativeTo: .body))
                        .fontWeight(.regular)
                        .foregroundColor(.auroMetalSaurus)
                }
            }
        }
    }
}

#if DEBUG
#Preview {
    SummaryLearningsView(
        keyLearnings: dummySummaries[0].keyLearnings ?? [],
        videoUrl: "https://example.com/video/teaser.mp4"
    )
}
#endif
