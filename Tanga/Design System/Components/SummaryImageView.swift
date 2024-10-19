//
//  SummaryImageView.swift
//  Tanga
//
//  Created by Rygel Louv on 06/10/2024.
//

import SwiftUI

struct SummaryImageView: View {
    var url: String
    
    var body: some View {
        AsyncImage(
            url: URL(string: url)) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(color: .gray.opacity(0.5), radius: 5, x: 0, y: 2)
            } else {
                Image("placeholder_image")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(color: .gray.opacity(0.5), radius: 5, x: 0, y: 2)
            }
        }
    }
}


#Preview {
    ZStack {
        SummaryImageView(url: "https://picsum.photos/i/237/400/400")
    }.frame(height: 200)
}
